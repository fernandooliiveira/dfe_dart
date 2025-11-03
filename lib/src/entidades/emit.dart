import 'package:xml/xml.dart';

/// Emitente da NF-e
class Emit {
  final String cnpj;
  final String xNome;
  final String? xFant;
  final EnderEmit enderEmit;
  final String ie;
  final String? iest;
  final String? im;
  final String? cnae;
  final String crt; // 1=Simples Nacional, 3=Regime Normal

  Emit({
    required this.cnpj,
    required this.xNome,
    this.xFant,
    required this.enderEmit,
    required this.ie,
    this.iest,
    this.im,
    this.cnae,
    required this.crt,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'emit',
      nest: () {
        builder.element('CNPJ', nest: cnpj);
        builder.element('xNome', nest: xNome);
        if (xFant != null) builder.element('xFant', nest: xFant);
        enderEmit.buildXml(builder);
        builder.element('IE', nest: ie);
        if (iest != null) builder.element('IEST', nest: iest);
        if (im != null) builder.element('IM', nest: im);
        if (cnae != null) builder.element('CNAE', nest: cnae);
        builder.element('CRT', nest: crt);
      },
    );
  }

  factory Emit.fromXml(XmlElement element) {
    return Emit(
      cnpj: element.findElements('CNPJ').first.innerText,
      xNome: element.findElements('xNome').first.innerText,
      xFant: element.findElements('xFant').isNotEmpty
          ? element.findElements('xFant').first.innerText
          : null,
      enderEmit: EnderEmit.fromXml(element.findElements('enderEmit').first),
      ie: element.findElements('IE').first.innerText,
      iest: element.findElements('IEST').isNotEmpty
          ? element.findElements('IEST').first.innerText
          : null,
      im: element.findElements('IM').isNotEmpty
          ? element.findElements('IM').first.innerText
          : null,
      cnae: element.findElements('CNAE').isNotEmpty
          ? element.findElements('CNAE').first.innerText
          : null,
      crt: element.findElements('CRT').first.innerText,
    );
  }
}

/// Endereço do emitente
class EnderEmit {
  final String xLgr;
  final String nro;
  final String? xCpl;
  final String xBairro;
  final String cMun;
  final String xMun;
  final String uf;
  final String cep;
  final String? cPais;
  final String? xPais;
  final String? fone;

  EnderEmit({
    required this.xLgr,
    required this.nro,
    this.xCpl,
    required this.xBairro,
    required this.cMun,
    required this.xMun,
    required this.uf,
    required this.cep,
    this.cPais,
    this.xPais,
    this.fone,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'enderEmit',
      nest: () {
        builder.element('xLgr', nest: xLgr);
        builder.element('nro', nest: nro);
        if (xCpl != null) builder.element('xCpl', nest: xCpl);
        builder.element('xBairro', nest: xBairro);
        builder.element('cMun', nest: cMun);
        builder.element('xMun', nest: xMun);
        builder.element('UF', nest: uf);
        builder.element('CEP', nest: cep);
        if (cPais != null) builder.element('cPais', nest: cPais);
        if (xPais != null) builder.element('xPais', nest: xPais);
        if (fone != null) builder.element('fone', nest: fone);
      },
    );
  }

  factory EnderEmit.fromXml(XmlElement element) {
    return EnderEmit(
      xLgr: element.findElements('xLgr').first.innerText,
      nro: element.findElements('nro').first.innerText,
      xCpl: element.findElements('xCpl').isNotEmpty
          ? element.findElements('xCpl').first.innerText
          : null,
      xBairro: element.findElements('xBairro').first.innerText,
      cMun: element.findElements('cMun').first.innerText,
      xMun: element.findElements('xMun').first.innerText,
      uf: element.findElements('UF').first.innerText,
      cep: element.findElements('CEP').first.innerText,
      cPais: element.findElements('cPais').isNotEmpty
          ? element.findElements('cPais').first.innerText
          : null,
      xPais: element.findElements('xPais').isNotEmpty
          ? element.findElements('xPais').first.innerText
          : null,
      fone: element.findElements('fone').isNotEmpty
          ? element.findElements('fone').first.innerText
          : null,
    );
  }
}
