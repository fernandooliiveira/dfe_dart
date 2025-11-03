import 'package:xml/xml.dart';

/// Destinatário da NF-e
class Dest {
  final String? cnpj;
  final String? cpf;
  final String? idEstrangeiro;
  final String? xNome;
  final EnderDest? enderDest;
  final String? indIEDest; // 1=Contribuinte, 2=Isento, 9=Não contribuinte
  final String? ie;
  final String? email;

  Dest({
    this.cnpj,
    this.cpf,
    this.idEstrangeiro,
    this.xNome,
    this.enderDest,
    this.indIEDest,
    this.ie,
    this.email,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'dest',
      nest: () {
        if (cnpj != null) builder.element('CNPJ', nest: cnpj);
        if (cpf != null) builder.element('CPF', nest: cpf);
        if (idEstrangeiro != null)
          builder.element('idEstrangeiro', nest: idEstrangeiro);
        if (xNome != null) builder.element('xNome', nest: xNome);
        if (enderDest != null) enderDest!.buildXml(builder);
        if (indIEDest != null) builder.element('indIEDest', nest: indIEDest);
        if (ie != null) builder.element('IE', nest: ie);
        if (email != null) builder.element('email', nest: email);
      },
    );
  }

  factory Dest.fromXml(XmlElement element) {
    return Dest(
      cnpj: element.findElements('CNPJ').isNotEmpty
          ? element.findElements('CNPJ').first.innerText
          : null,
      cpf: element.findElements('CPF').isNotEmpty
          ? element.findElements('CPF').first.innerText
          : null,
      idEstrangeiro: element.findElements('idEstrangeiro').isNotEmpty
          ? element.findElements('idEstrangeiro').first.innerText
          : null,
      xNome: element.findElements('xNome').isNotEmpty
          ? element.findElements('xNome').first.innerText
          : null,
      enderDest: element.findElements('enderDest').isNotEmpty
          ? EnderDest.fromXml(element.findElements('enderDest').first)
          : null,
      indIEDest: element.findElements('indIEDest').isNotEmpty
          ? element.findElements('indIEDest').first.innerText
          : null,
      ie: element.findElements('IE').isNotEmpty
          ? element.findElements('IE').first.innerText
          : null,
      email: element.findElements('email').isNotEmpty
          ? element.findElements('email').first.innerText
          : null,
    );
  }
}

/// Endereço do destinatário
class EnderDest {
  final String xLgr;
  final String nro;
  final String? xCpl;
  final String xBairro;
  final String cMun;
  final String xMun;
  final String uf;
  final String? cep;
  final String? cPais;
  final String? xPais;
  final String? fone;

  EnderDest({
    required this.xLgr,
    required this.nro,
    this.xCpl,
    required this.xBairro,
    required this.cMun,
    required this.xMun,
    required this.uf,
    this.cep,
    this.cPais,
    this.xPais,
    this.fone,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'enderDest',
      nest: () {
        builder.element('xLgr', nest: xLgr);
        builder.element('nro', nest: nro);
        if (xCpl != null) builder.element('xCpl', nest: xCpl);
        builder.element('xBairro', nest: xBairro);
        builder.element('cMun', nest: cMun);
        builder.element('xMun', nest: xMun);
        builder.element('UF', nest: uf);
        if (cep != null) builder.element('CEP', nest: cep);
        if (cPais != null) builder.element('cPais', nest: cPais);
        if (xPais != null) builder.element('xPais', nest: xPais);
        if (fone != null) builder.element('fone', nest: fone);
      },
    );
  }

  factory EnderDest.fromXml(XmlElement element) {
    return EnderDest(
      xLgr: element.findElements('xLgr').first.innerText,
      nro: element.findElements('nro').first.innerText,
      xCpl: element.findElements('xCpl').isNotEmpty
          ? element.findElements('xCpl').first.innerText
          : null,
      xBairro: element.findElements('xBairro').first.innerText,
      cMun: element.findElements('cMun').first.innerText,
      xMun: element.findElements('xMun').first.innerText,
      uf: element.findElements('UF').first.innerText,
      cep: element.findElements('CEP').isNotEmpty
          ? element.findElements('CEP').first.innerText
          : null,
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
