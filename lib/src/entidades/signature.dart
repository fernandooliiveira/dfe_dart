import 'package:xml/xml.dart';

/// Representa a assinatura XML anexada em documentos assinados.
class Signature {
  final String signedInfo;
  final String signatureValue;
  final String keyInfo;

  Signature({
    required this.signedInfo,
    required this.signatureValue,
    required this.keyInfo,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'Signature',
      nest: () {
        builder.attribute('xmlns', 'http://www.w3.org/2000/09/xmldsig#');
        builder.xml(signedInfo);
        builder.element('SignatureValue', nest: signatureValue);
        builder.xml(keyInfo);
      },
    );
  }

  factory Signature.fromXml(XmlElement element) {
    return Signature(
      signedInfo: element.findElements('SignedInfo').first.toXmlString(),
      signatureValue: element.findElements('SignatureValue').first.innerText,
      keyInfo: element.findElements('KeyInfo').first.toXmlString(),
    );
  }
}
