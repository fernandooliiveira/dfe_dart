import 'package:xml/xml.dart';
import 'package:dfe_dart/src/enum/_init.dart';
import 'package:dfe_dart/src/models/endereco.dart';

class EmitModel {
  final String? cnpj;
  final String? cpf;
  final String xNome;
  final String? xFant;
  final EnderecoModel enderEmit;
  final String? ie;
  final String? iest;
  final String? im;
  final String? cnae;
  final ECrt crt;

  const EmitModel({
    this.cnpj,
    this.cpf,
    required this.xNome,
    this.xFant,
    required this.enderEmit,
    this.ie,
    this.iest,
    this.im,
    this.cnae,
    required this.crt,
  }) : assert(cnpj != null || cpf != null, 'cnpj or cpf must be provided');

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('emit', nest: () {
      if (cnpj != null) builder.element('CNPJ', nest: cnpj!);
      if (cpf != null) builder.element('CPF', nest: cpf!);
      builder.element('xNome', nest: xNome);
      if (xFant != null) builder.element('xFant', nest: xFant!);
      builder.element('enderEmit', nest: () {
        final enderecoElement = enderEmit.writeXml('enderEmit');
        for (final child in enderecoElement.children) {
          builder.xml(child.toXmlString());
        }
      });
      if (ie != null) builder.element('IE', nest: ie!);
      if (iest != null) builder.element('IEST', nest: iest!);
      if (im != null) builder.element('IM', nest: im!);
      if (cnae != null) builder.element('CNAE', nest: cnae!);
      builder.element('CRT', nest: crt.xmlValue);
    });
    return builder.buildDocument().rootElement;
  }

  static EmitModel fromXml(XmlElement element) {
    String? text(String tag) {
      final els = element.findElements(tag);
      return els.isEmpty ? null : els.single.innerText;
    }

    String req(String tag) => element.findElements(tag).single.innerText;

    final enderecoEl = element.findElements('enderEmit').single;

    return EmitModel(
      cnpj: text('CNPJ'),
      cpf: text('CPF'),
      xNome: req('xNome'),
      xFant: text('xFant'),
      enderEmit: EnderecoModel.fromXml(enderecoEl),
      ie: text('IE'),
      iest: text('IEST'),
      im: text('IM'),
      cnae: text('CNAE'),
      crt: ECrt.values.firstWhere((e) => e.xmlValue == req('CRT')),
    );
  }
}
