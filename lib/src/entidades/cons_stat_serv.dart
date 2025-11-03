import 'package:xml/xml.dart';

/// Dados para a consulta de status de servico.
class ConsStatServ {
  final String versao;
  final String tpAmb;
  final String cUF;
  final String xServ;

  ConsStatServ({
    this.versao = '4.00',
    required this.tpAmb,
    required this.cUF,
    this.xServ = 'STATUS',
  });

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'consStatServ',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('cUF', nest: cUF);
        builder.element('xServ', nest: xServ);
      },
    );
  }

  factory ConsStatServ.fromDocument(XmlDocument doc) {
    return ConsStatServ.fromXml(doc.rootElement);
  }

  factory ConsStatServ.fromXml(XmlElement element) {
    return ConsStatServ(
      versao: element.getAttribute('versao') ?? '4.00',
      tpAmb: element.findElements('tpAmb').first.innerText,
      cUF: element.findElements('cUF').first.innerText,
      xServ: element.findElements('xServ').first.innerText,
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}
