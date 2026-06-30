import 'package:xml/xml.dart';
import 'package:dfe_dart/src/enum/_init.dart';

class EnderecoModel {
  final String xLgr;
  final String nro;
  final String? xCpl;
  final String xBairro;
  final int cMun;
  final String xMun;
  final EEstado uf;
  final String cep;
  final String? cPais;
  final String? xPais;
  final String? fone;

  const EnderecoModel({
    required this.xLgr,
    required this.nro,
    this.xCpl,
    required this.xBairro,
    required this.cMun,
    required this.xMun,
    required this.uf,
    required this.cep,
    this.cPais = '1058',
    this.xPais = 'Brasil',
    this.fone,
  });

  XmlElement writeXml(String tagName) {
    final builder = XmlBuilder();
    builder.element(tagName, nest: () {
      builder.element('xLgr', nest: xLgr);
      builder.element('nro', nest: nro);
      if (xCpl != null) builder.element('xCpl', nest: xCpl);
      builder.element('xBairro', nest: xBairro);
      builder.element('cMun', nest: cMun.toString());
      builder.element('xMun', nest: xMun);
      builder.element('UF', nest: uf.name.toUpperCase());
      builder.element('CEP', nest: cep);
      if (cPais != null) builder.element('cPais', nest: cPais);
      if (xPais != null) builder.element('xPais', nest: xPais);
      if (fone != null) builder.element('fone', nest: fone);
    });
    return builder.buildDocument().rootElement.copy();
  }

  static EnderecoModel fromXml(XmlElement element) {
    String? getText(String tag) =>
        element.getElement(tag)?.innerText;

    final ufStr = getText('UF')?.toLowerCase() ?? '';
    final uf = EEstado.values.firstWhere(
      (e) => e.name == ufStr,
      orElse: () => EEstado.values.first,
    );

    return EnderecoModel(
      xLgr: getText('xLgr') ?? '',
      nro: getText('nro') ?? '',
      xCpl: getText('xCpl'),
      xBairro: getText('xBairro') ?? '',
      cMun: int.parse(getText('cMun') ?? '0'),
      xMun: getText('xMun') ?? '',
      uf: uf,
      cep: getText('CEP') ?? '',
      cPais: getText('cPais') ?? '1058',
      xPais: getText('xPais') ?? 'Brasil',
      fone: getText('fone'),
    );
  }
}
