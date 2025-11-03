import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:pointycastle/export.dart';
import 'package:xml/xml.dart';
import 'package:xml_sign_dart/src/certificado.dart';
import 'package:xml_sign_dart/src/entidades/nfe.dart';
import 'package:xml_sign_dart/src/xml_c14n.dart';

enum HashAlgo { sha1, sha256 }

enum TipoAssinatura {
  nfe('NFe', 'infNFe'),
  inutilizacao('inutNFe', 'infInut'),
  evento('evento', 'infEvento');

  const TipoAssinatura(this.containerTag, this.targetTag);

  final String containerTag;
  final String targetTag;
}

class _XmlSignatureUris {
  static const ds = 'http://www.w3.org/2000/09/xmldsig#';
  static const excC14N = 'http://www.w3.org/2001/10/xml-exc-c14n#';
  static const sha1 = 'http://www.w3.org/2000/09/xmldsig#sha1';
  static const sha256 = 'http://www.w3.org/2001/04/xmlenc#sha256';
  static const rsaSha1 = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1';
  static const rsaSha256 = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256';
  static const envelopedSignature =
      'http://www.w3.org/2000/09/xmldsig#enveloped-signature';
}

NFe assinarNFe({
  required NFe nfe,
  required CertBundle cert,
  HashAlgo algo = HashAlgo.sha256,
}) {
  final xmlDoc = nfe.toXml();
  final xmlString = xmlDoc.toXmlString();

  final xmlAssinado = assinarXml(
    xmlOriginal: xmlString,
    cert: cert,
    tipo: TipoAssinatura.nfe,
    algo: algo,
  );

  final docAssinado = XmlDocument.parse(xmlAssinado);
  return NFe.fromXml(docAssinado);
}

List<NFe> assinarLoteNFe({
  required List<NFe> nfes,
  required CertBundle cert,
  HashAlgo algo = HashAlgo.sha256,
}) {
  return nfes
      .map((nfe) => assinarNFe(nfe: nfe, cert: cert, algo: algo))
      .toList();
}

String assinarXml({
  required String xmlOriginal,
  required CertBundle cert,
  required TipoAssinatura tipo,
  HashAlgo algo = HashAlgo.sha256,
}) {
  final doc = XmlDocument.parse(xmlOriginal);

  final elementosParaAssinar = doc.descendants
      .whereType<XmlElement>()
      .where((element) => element.name.local == tipo.targetTag)
      .toList();

  if (elementosParaAssinar.isEmpty) {
    throw Exception('Elemento <${tipo.targetTag}> não encontrado no XML.');
  }

  for (final elemento in elementosParaAssinar) {
    final idAttr = elemento.getAttribute('Id');
    if (idAttr == null || idAttr.isEmpty) {
      throw Exception('Atributo Id não encontrado em <${tipo.targetTag}>.');
    }

    final canonicalizado = canonicalizeC14N(elemento);
    final digestValue = base64Encode(_calcularDigest(canonicalizado, algo));

    final signedInfoElement = _montarSignedInfo(
      refId: idAttr,
      digestValue: digestValue,
      algo: algo,
    );

    final signedInfoCanonical = canonicalizeC14N(signedInfoElement);
    final signatureValue = _assinarSignedInfo(
      canonicalizedSignedInfo: signedInfoCanonical,
      cert: cert,
      algo: algo,
    );

    final signatureElement = _montarSignature(
      signedInfoElement: signedInfoElement,
      signatureValue: signatureValue,
      certBase64: cert.certB64,
    );

    final elementoPaiNode = elemento.parent;
    if (elementoPaiNode == null) {
      throw StateError('Elemento <${tipo.targetTag}> sem elemento pai.');
    }
    if (elementoPaiNode is! XmlElement) {
      throw StateError(
        'O pai de <${tipo.targetTag}> não é um elemento XML válido para assinatura.',
      );
    }
    final elementoPai = elementoPaiNode;

    _removerAssinaturasExistentes(elementoPai);

    if (tipo == TipoAssinatura.nfe) {
      final infNFeSupl = elementoPai.children
          .whereType<XmlElement>()
          .where((child) => child.name.local == 'infNFeSupl')
          .toList();

      if (infNFeSupl.isNotEmpty) {
        final indexSupl = elementoPai.children.indexOf(infNFeSupl.first);
        elementoPai.children.insert(indexSupl, signatureElement.copy());
        continue;
      }
    }

    elementoPai.children.add(signatureElement.copy());
  }

  return doc.toXmlString();
}

bool xmlEstaAssinado(String xml) {
  try {
    final doc = XmlDocument.parse(xml);
    return doc.descendants.whereType<XmlElement>().any(
      (element) => element.name.local == 'Signature',
    );
  } catch (_) {
    return false;
  }
}

bool nfeEstaAssinada(NFe nfe) => nfe.signature != null;

String removerAssinatura(String xml) {
  final doc = XmlDocument.parse(xml);
  final signatures = doc.findAllElements('Signature').toList();

  for (final sig in signatures) {
    sig.parent?.children.remove(sig);
  }

  return doc.toXmlString();
}

NFe removerAssinaturaNFe(NFe nfe) {
  return NFe(infNFe: nfe.infNFe, signature: null, infNFeSupl: nfe.infNFeSupl);
}

Uint8List _calcularDigest(String canonicalizado, HashAlgo algo) {
  final bytes = utf8.encode(canonicalizado);
  final digest = algo == HashAlgo.sha1
      ? crypto.sha1.convert(bytes)
      : crypto.sha256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}

XmlElement _montarSignedInfo({
  required String refId,
  required String digestValue,
  required HashAlgo algo,
}) {
  final canonicalizationMethod = XmlElement(XmlName('CanonicalizationMethod'), [
    XmlAttribute(XmlName('Algorithm'), _XmlSignatureUris.excC14N),
  ], const []);

  final signatureMethod = XmlElement(XmlName('SignatureMethod'), [
    XmlAttribute(
      XmlName('Algorithm'),
      algo == HashAlgo.sha1
          ? _XmlSignatureUris.rsaSha1
          : _XmlSignatureUris.rsaSha256,
    ),
  ], const []);

  final transforms = XmlElement(XmlName('Transforms'), const [], [
    XmlElement(XmlName('Transform'), [
      XmlAttribute(XmlName('Algorithm'), _XmlSignatureUris.envelopedSignature),
    ], const []),
    XmlElement(XmlName('Transform'), [
      XmlAttribute(XmlName('Algorithm'), _XmlSignatureUris.excC14N),
    ], const []),
  ]);

  final digestMethod = XmlElement(XmlName('DigestMethod'), [
    XmlAttribute(
      XmlName('Algorithm'),
      algo == HashAlgo.sha1 ? _XmlSignatureUris.sha1 : _XmlSignatureUris.sha256,
    ),
  ], const []);

  final digestValueElement = XmlElement(XmlName('DigestValue'), const [], [
    XmlText(digestValue),
  ]);

  final reference = XmlElement(
    XmlName('Reference'),
    [XmlAttribute(XmlName('URI'), '#$refId')],
    [transforms, digestMethod, digestValueElement],
  );

  return XmlElement(
    XmlName('SignedInfo'),
    [XmlAttribute(XmlName('xmlns'), _XmlSignatureUris.ds)],
    [canonicalizationMethod, signatureMethod, reference],
  );
}

String _assinarSignedInfo({
  required String canonicalizedSignedInfo,
  required CertBundle cert,
  required HashAlgo algo,
}) {
  final signer = Signer(algo == HashAlgo.sha1 ? 'SHA-1/RSA' : 'SHA-256/RSA');
  signer.init(true, PrivateKeyParameter<RSAPrivateKey>(cert.privateKey));

  final dataBytes = Uint8List.fromList(utf8.encode(canonicalizedSignedInfo));
  final signature = signer.generateSignature(dataBytes) as RSASignature;

  return base64Encode(signature.bytes);
}

XmlElement _montarSignature({
  required XmlElement signedInfoElement,
  required String signatureValue,
  required String certBase64,
}) {
  final signatureValueElement = XmlElement(
    XmlName('SignatureValue'),
    const [],
    [XmlText(signatureValue)],
  );

  final keyInfoElement = XmlElement(XmlName('KeyInfo'), const [], [
    XmlElement(XmlName('X509Data'), const [], [
      XmlElement(XmlName('X509Certificate'), const [], [XmlText(certBase64)]),
    ]),
  ]);

  return XmlElement(
    XmlName('Signature'),
    [XmlAttribute(XmlName('xmlns'), _XmlSignatureUris.ds)],
    [signedInfoElement.copy(), signatureValueElement, keyInfoElement],
  );
}

void _removerAssinaturasExistentes(XmlElement elementoPai) {
  final assinaturas = elementoPai.children
      .whereType<XmlElement>()
      .where((element) => element.name.local == 'Signature')
      .toList();

  for (final assinatura in assinaturas) {
    assinatura.parent?.children.remove(assinatura);
  }
}
