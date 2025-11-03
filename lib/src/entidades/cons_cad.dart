import 'package:xml/xml.dart';

/// Consulta cadastro de contribuintes.
class ConsCad {
  final String versao;
  final InfCons infCons;

  ConsCad({this.versao = '2.00', required this.infCons});

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ConsCad',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        infCons.buildXml(builder);
      },
    );
  }

  factory ConsCad.fromDocument(XmlDocument doc) {
    return ConsCad.fromXml(doc.rootElement);
  }

  factory ConsCad.fromXml(XmlElement element) {
    return ConsCad(
      versao: element.getAttribute('versao') ?? '2.00',
      infCons: InfCons.fromXml(element.findElements('infCons').first),
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}

class InfCons {
  final String xServ;
  final String uf;
  final String? ie;
  final String? cnpj;
  final String? cpf;
  final String? xNome;
  InfCons({
    this.xServ = 'CONS-CAD',
    required this.uf,
    this.ie,
    this.cnpj,
    this.cpf,
    this.xNome,
  }) : assert(
         ie != null || cnpj != null || cpf != null,
         'Informe IE, CNPJ ou CPF.',
       );

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infCons',
      nest: () {
        builder.element('xServ', nest: xServ);
        builder.element('UF', nest: uf);
        if (ie != null) {
          builder.element('IE', nest: ie);
        }
        if (cnpj != null) {
          builder.element('CNPJ', nest: cnpj);
        }
        if (cpf != null) {
          builder.element('CPF', nest: cpf);
        }
        if (xNome != null) {
          builder.element('xNome', nest: xNome);
        }
      },
    );
  }

  factory InfCons.fromXml(XmlElement element) {
    String? _text(String tag) {
      final nodes = element.findElements(tag);
      return nodes.isNotEmpty ? nodes.first.innerText : null;
    }

    return InfCons(
      xServ: element.findElements('xServ').first.innerText,
      uf: element.findElements('UF').first.innerText,
      ie: _text('IE'),
      cnpj: _text('CNPJ'),
      cpf: _text('CPF'),
      xNome: _text('xNome'),
    );
  }
}
