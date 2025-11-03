import 'package:xml/xml.dart';

/// Informações adicionais
class InfAdic {
  final String? infCpl;
  final String? infAdFisco;

  InfAdic({this.infCpl, this.infAdFisco});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infAdic',
      nest: () {
        if (infAdFisco != null) builder.element('infAdFisco', nest: infAdFisco);
        if (infCpl != null) builder.element('infCpl', nest: infCpl);
      },
    );
  }

  factory InfAdic.fromXml(XmlElement element) {
    return InfAdic(
      infCpl: element.findElements('infCpl').isNotEmpty
          ? element.findElements('infCpl').first.innerText
          : null,
      infAdFisco: element.findElements('infAdFisco').isNotEmpty
          ? element.findElements('infAdFisco').first.innerText
          : null,
    );
  }
}

/// Informações do responsável técnico
class InfRespTec {
  final String cnpj;
  final String xContato;
  final String email;
  final String fone;

  InfRespTec({
    required this.cnpj,
    required this.xContato,
    required this.email,
    required this.fone,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infRespTec',
      nest: () {
        builder.element('CNPJ', nest: cnpj);
        builder.element('xContato', nest: xContato);
        builder.element('email', nest: email);
        builder.element('fone', nest: fone);
      },
    );
  }

  factory InfRespTec.fromXml(XmlElement element) {
    return InfRespTec(
      cnpj: element.findElements('CNPJ').first.innerText,
      xContato: element.findElements('xContato').first.innerText,
      email: element.findElements('email').first.innerText,
      fone: element.findElements('fone').first.innerText,
    );
  }
}
