import 'package:xml/xml.dart';

/// Dados para consulta de recibo de autorizacao.
class ConsReciNFe {
  final String versao;
  final String tpAmb;
  final String nRec;

  ConsReciNFe({this.versao = '4.00', required this.tpAmb, required this.nRec});

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'consReciNFe',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('nRec', nest: nRec);
      },
    );
  }

  factory ConsReciNFe.fromDocument(XmlDocument doc) {
    return ConsReciNFe.fromXml(doc.rootElement);
  }

  factory ConsReciNFe.fromXml(XmlElement element) {
    return ConsReciNFe(
      versao: element.getAttribute('versao') ?? '4.00',
      tpAmb: element.findElements('tpAmb').first.innerText,
      nRec: element.findElements('nRec').first.innerText,
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}
