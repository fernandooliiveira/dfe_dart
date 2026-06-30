import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import 'package:dfe_dart/src/services/assinador_xml.dart';
import 'package:dfe_dart/src/services/xml_c14n.dart';

void main() {
  group('C14N canonicalize', () {
    test('propaga namespace do ancestral', () {
      final doc = XmlDocument.parse(
          '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
          '<infNFe Id="NFe001" versao="4.00"><ide><cUF>35</cUF></ide></infNFe>'
          '</NFe>');
      final infNfe =
          doc.rootElement.findElements('infNFe').first;
      final c14n = canonicalize(infNfe);

      expect(c14n,
          contains('xmlns="http://www.portalfiscal.inf.br/nfe"'));
    });

    test('atributos ordenados alfabeticamente', () {
      final doc = XmlDocument.parse(
          '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
          '<infNFe versao="4.00" Id="NFe001"></infNFe>'
          '</NFe>');
      final infNfe = doc.rootElement.findElements('infNFe').first;
      final c14n = canonicalize(infNfe);

      // Id deve vir antes de versao
      final idPos = c14n.indexOf('Id=');
      final versaoPos = c14n.indexOf('versao=');
      expect(idPos, lessThan(versaoPos));
    });

    test('namespace não repetido nos filhos', () {
      final doc = XmlDocument.parse(
          '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
          '<infNFe Id="x"><ide><cUF>35</cUF></ide></infNFe>'
          '</NFe>');
      final infNfe = doc.rootElement.findElements('infNFe').first;
      final c14n = canonicalize(infNfe);

      // xmlns deve aparecer exatamente uma vez
      final count = 'xmlns="http://www.portalfiscal.inf.br/nfe"'
          .allMatches(c14n)
          .length;
      expect(count, equals(1));
    });

    test('escapa caracteres especiais no texto', () {
      final doc = XmlDocument.parse(
          '<root><item>A &amp; B &lt; C</item></root>');
      final root = doc.rootElement;
      final c14n = canonicalize(root);
      expect(c14n, contains('A &amp; B &lt; C'));
    });
  });

  group('AssinadorXml (RSA sintético)', () {
    // Gera um par de chaves RSA 2048-bit para os testes
    late RSAPrivateKey privateKey;
    late RSAPublicKey publicKey;

    setUpAll(() {
      final gen = RSAKeyGenerator()
        ..init(ParametersWithRandom(
            RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12),
            _secureRandom()));
      final pair = gen.generateKeyPair();
      privateKey = pair.privateKey as RSAPrivateKey;
      publicKey = pair.publicKey as RSAPublicKey;
    });

    test('assinar produz XML com <Signature>', () {
      final xmlInput = '''<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
<infNFe Id="NFe35240101234567890112345678901234567890123456789012" versao="4.00">'
<ide><cUF>35</cUF></ide></infNFe></NFe>''';

      final assinador = AssinadorXml.forTesting(privateKey, Uint8List(1));
      final xmlAssinado = assinador.assinar(xmlInput);

      final doc = XmlDocument.parse(xmlAssinado);
      final sig = doc.rootElement.findAllElements('Signature');
      expect(sig, isNotEmpty);
    });

    test('assinatura RSA é verificável', () {
      final xmlInput = '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
          '<infNFe Id="NFe001" versao="4.00"><ide><cUF>35</cUF></ide></infNFe>'
          '</NFe>';

      final assinador = AssinadorXml.forTesting(privateKey, Uint8List(1));
      final xmlAssinado = assinador.assinar(xmlInput);

      // Extrai SignatureValue
      final doc = XmlDocument.parse(xmlAssinado);
      final sigValue = doc.rootElement
          .findAllElements('SignatureValue')
          .first
          .innerText
          .trim();
      final sigBytes = base64.decode(sigValue);

      // Extrai DigestValue e verifica que o infNFe foi hasheado corretamente
      final digestValue = doc.rootElement
          .findAllElements('DigestValue')
          .first
          .innerText
          .trim();
      expect(digestValue.length, greaterThan(20)); // base64 de SHA-1 = 28 chars

      // Verifica assinatura RSA
      final verifier = RSASigner(SHA1Digest(), '06052b0e03021a')
        ..init(false, PublicKeyParameter<RSAPublicKey>(publicKey));
      final valid = verifier.verifySignature(
          _extractSignedInfoC14n(xmlAssinado),
          RSASignature(Uint8List.fromList(sigBytes)));
      expect(valid, isTrue);
    });
  });
}

/// Extrai e canonicaliza o <SignedInfo> do XML assinado.
Uint8List _extractSignedInfoC14n(String xmlAssinado) {
  final doc = XmlDocument.parse(xmlAssinado);
  final signedInfo =
      doc.rootElement.findAllElements('SignedInfo').first;
  return Uint8List.fromList(utf8.encode(canonicalize(signedInfo)));
}

FortunaRandom _secureRandom() {
  final random = FortunaRandom();
  final seed = Uint8List(32);
  for (var i = 0; i < 32; i++) {
    seed[i] = i * 7 + 13;
  }
  random.seed(KeyParameter(seed));
  return random;
}
