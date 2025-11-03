import 'package:xml/xml.dart';

/// Administracao do CSC da NFC-e (solicitar, consultar, desabilitar).
class AdmCscNfce {
  final String versao;
  final String tpAmb;
  final String xServ;
  final String cnpj;
  final String? idCSC;
  final String? csc;

  AdmCscNfce({
    this.versao = '1.00',
    required this.tpAmb,
    this.xServ = 'CONSULTAR',
    required this.cnpj,
    this.idCSC,
    this.csc,
  });

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'admCscNFCe',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('xServ', nest: xServ);
        builder.element('CNPJ', nest: cnpj);
        if (idCSC != null) {
          builder.element('idCSC', nest: idCSC);
        }
        if (csc != null) {
          builder.element('csc', nest: csc);
        }
      },
    );
  }

  factory AdmCscNfce.fromDocument(XmlDocument doc) {
    return AdmCscNfce.fromXml(doc.rootElement);
  }

  factory AdmCscNfce.fromXml(XmlElement element) {
    String? _text(String tag) {
      final nodes = element.findElements(tag);
      return nodes.isNotEmpty ? nodes.first.innerText : null;
    }

    return AdmCscNfce(
      versao: element.getAttribute('versao') ?? '1.00',
      tpAmb: element.findElements('tpAmb').first.innerText,
      xServ: element.findElements('xServ').first.innerText,
      cnpj: element.findElements('CNPJ').first.innerText,
      idCSC: _text('idCSC'),
      csc: _text('csc'),
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}
