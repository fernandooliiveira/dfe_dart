import 'package:xml/xml.dart';
import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/models/endereco.dart';

class DestModel {
  final String? cnpj;
  final String? cpf;
  final String? idEstrangeiro;
  final String? xNome;
  final EnderecoModel? enderDest;
  final EIndicadorIEDest indIEDest;
  final String? ie;
  final String? isuf;
  final String? im;
  final String? email;

  const DestModel({
    this.cnpj,
    this.cpf,
    this.idEstrangeiro,
    this.xNome,
    this.enderDest,
    required this.indIEDest,
    this.ie,
    this.isuf,
    this.im,
    this.email,
  });

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('dest', nest: () {
      if (cnpj != null) builder.element('CNPJ', nest: cnpj!);
      if (cpf != null) builder.element('CPF', nest: cpf!);
      if (idEstrangeiro != null) builder.element('idEstrangeiro', nest: idEstrangeiro!);
      if (xNome != null) builder.element('xNome', nest: xNome!);
      if (enderDest != null) {
        builder.xml(enderDest!.writeXml('enderDest').toXmlString());
      }
      builder.element('indIEDest', nest: indIEDest.xmlValue);
      if (ie != null) builder.element('IE', nest: ie!);
      if (isuf != null) builder.element('ISUF', nest: isuf!);
      if (im != null) builder.element('IM', nest: im!);
      if (email != null) builder.element('email', nest: email!);
    });
    return builder.buildDocument().rootElement;
  }

  static DestModel fromXml(XmlElement element) {
    String? text(String tag) {
      final els = element.findElements(tag);
      return els.isEmpty ? null : els.single.innerText;
    }

    String req(String tag) => element.findElements(tag).single.innerText;

    final enderDestEl = element.findElements('enderDest');
    final enderDest = enderDestEl.isEmpty
        ? null
        : EnderecoModel.fromXml(enderDestEl.single);

    return DestModel(
      cnpj: text('CNPJ'),
      cpf: text('CPF'),
      idEstrangeiro: text('idEstrangeiro'),
      xNome: text('xNome'),
      enderDest: enderDest,
      indIEDest: EIndicadorIEDest.values.firstWhere(
        (e) => e.xmlValue == req('indIEDest'),
      ),
      ie: text('IE'),
      isuf: text('ISUF'),
      im: text('IM'),
      email: text('email'),
    );
  }
}
