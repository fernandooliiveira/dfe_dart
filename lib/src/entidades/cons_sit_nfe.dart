import 'package:xml/xml.dart';

/// Dados para consulta de situacao de uma NFe ou NFCe especifica.
class ConsSitNFe {
  final String versao;
  final String tpAmb;
  final String chNFe;
  final String xServ;

  ConsSitNFe({
    this.versao = '4.00',
    required this.tpAmb,
    required this.chNFe,
    this.xServ = 'CONSULTAR',
  });

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'consSitNFe',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('xServ', nest: xServ);
        builder.element('chNFe', nest: chNFe);
      },
    );
  }

  factory ConsSitNFe.fromDocument(XmlDocument doc) {
    return ConsSitNFe.fromXml(doc.rootElement);
  }

  factory ConsSitNFe.fromXml(XmlElement element) {
    return ConsSitNFe(
      versao: element.getAttribute('versao') ?? '4.00',
      tpAmb: element.findElements('tpAmb').first.innerText,
      xServ: element.findElements('xServ').first.innerText,
      chNFe: element.findElements('chNFe').first.innerText,
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}
