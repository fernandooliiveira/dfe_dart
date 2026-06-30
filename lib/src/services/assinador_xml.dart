import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:xml/xml.dart';

import 'pkcs12_reader.dart';
import 'xml_c14n.dart';

const _xmldsig = 'http://www.w3.org/2000/09/xmldsig#';
const _c14nAlg = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315';

/// Assina um XML de NF-e/NFC-e com certificado A1 (PFX/P12), conforme XML-DSig.
///
/// Uso:
/// ```dart
/// final pfxBytes = File('cert.pfx').readAsBytesSync();
/// final assinador = AssinadorXml.fromPfx(pfxBytes, 'senha');
/// final xmlAssinado = assinador.assinar(xmlNaoAssinado);
/// ```
class AssinadorXml {
  final RSAPrivateKey _privateKey;
  final Uint8List _certDer;

  AssinadorXml._(this._privateKey, this._certDer);

  /// Construtor para testes: injeta a chave e o certificado diretamente.
  // ignore: prefer_constructors_over_static_methods
  factory AssinadorXml.forTesting(RSAPrivateKey privateKey, Uint8List certDer) =>
      AssinadorXml._(privateKey, certDer);

  /// Carrega a chave privada e o certificado a partir de um arquivo PFX/P12.
  factory AssinadorXml.fromPfx(Uint8List pfxBytes, String senha) {
    final result = Pkcs12Reader.parse(pfxBytes, senha);
    return AssinadorXml._(result.privateKey, result.certDer);
  }

  /// Resultado completo do PFX — inclui [pkcs8Der] para criar um [SefazClient].
  static Pkcs12Result parsePfx(Uint8List pfxBytes, String senha) =>
      Pkcs12Reader.parse(pfxBytes, senha);

  /// Assina o XML e retorna a string XML com a assinatura embutida.
  ///
  /// O XML deve conter um elemento raiz `<NFe>` (ou `<nfeProc>`) com um único
  /// filho `<infNFe Id="NFe...">`. A assinatura é anexada como filho da raiz.
  String assinar(String xmlNaoAssinado) {
    final doc = XmlDocument.parse(xmlNaoAssinado);
    final root = doc.rootElement;

    // Localiza o elemento assinável: primeiro filho com atributo Id
    final infNfe = root.children
        .whereType<XmlElement>()
        .firstWhere((e) => e.getAttribute('Id') != null,
            orElse: () => throw StateError(
                'Não foi encontrado elemento com atributo Id para assinar.'));

    final id = infNfe.getAttribute('Id')!;
    final uri = '#$id';

    // ── 1. Digest do infNFe (C14N → SHA-1 → base64) ──────────────────────
    final infNfeC14n = canonicalize(infNfe);
    final digestValue = _sha1Base64(utf8.encode(infNfeC14n));

    // ── 2. Monta o SignedInfo XML ─────────────────────────────────────────
    final signedInfoXml = _buildSignedInfo(uri, digestValue);

    // ── 3. Canonicaliza o SignedInfo e assina com RSA-SHA1 ────────────────
    final signedInfoDoc = XmlDocument.parse(signedInfoXml);
    final signedInfoEl = signedInfoDoc.rootElement;
    final signedInfoC14n = canonicalize(signedInfoEl);
    final signatureValue = _rsaSha1Sign(utf8.encode(signedInfoC14n));

    // ── 4. Monta o elemento <Signature> completo ──────────────────────────
    final signatureEl = _buildSignatureElement(
        signedInfoXml, signatureValue, base64.encode(_certDer));

    // ── 5. Insere a assinatura no documento original ──────────────────────
    root.children.add(signatureEl);
    return doc.toXmlString();
  }

  // ─── Private helpers ─────────────────────────────────────────────────────

  String _buildSignedInfo(String uri, String digestValue) => '''<SignedInfo xmlns="$_xmldsig"><CanonicalizationMethod Algorithm="$_c14nAlg"/><SignatureMethod Algorithm="${_xmldsig}rsa-sha1"/><Reference URI="$uri"><Transforms><Transform Algorithm="${_xmldsig}enveloped-signature"/><Transform Algorithm="$_c14nAlg"/></Transforms><DigestMethod Algorithm="${_xmldsig}sha1"/><DigestValue>$digestValue</DigestValue></Reference></SignedInfo>''';

  XmlElement _buildSignatureElement(
      String signedInfoXml, String signatureValue, String certB64) {
    // Remove a declaração XML se houver, mantém só o elemento
    final signedInfoEl =
        XmlDocument.parse(signedInfoXml).rootElement.copy();

    final builder = XmlBuilder();
    builder.element('Signature', attributes: {'xmlns': _xmldsig}, nest: () {
      builder.xml(signedInfoEl.toXmlString());
      builder.element('SignatureValue', nest: () => builder.text(signatureValue));
      builder.element('KeyInfo', nest: () {
        builder.element('X509Data', nest: () {
          builder.element('X509Certificate',
              nest: () => builder.text(certB64));
        });
      });
    });
    return builder.buildDocument().rootElement.copy();
  }

  String _sha1Base64(List<int> data) {
    final digest = SHA1Digest();
    final out = Uint8List(digest.digestSize);
    digest
      ..update(Uint8List.fromList(data), 0, data.length)
      ..doFinal(out, 0);
    return base64.encode(out);
  }

  String _rsaSha1Sign(List<int> data) {
    final signer = RSASigner(SHA1Digest(), '06052b0e03021a')
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(_privateKey));
    final sig = signer.generateSignature(Uint8List.fromList(data));
    return base64.encode(sig.bytes);
  }
}
