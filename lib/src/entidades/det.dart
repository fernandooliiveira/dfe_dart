import 'package:xml/xml.dart';

/// Detalhe de produto/serviço da NF-e
class Det {
  final String nItem;
  final Prod prod;
  final Imposto imposto;
  final InfAdProd? infAdProd;

  Det({
    required this.nItem,
    required this.prod,
    required this.imposto,
    this.infAdProd,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'det',
      nest: () {
        builder.attribute('nItem', nItem);
        prod.buildXml(builder);
        imposto.buildXml(builder);
        if (infAdProd != null) infAdProd!.buildXml(builder);
      },
    );
  }

  factory Det.fromXml(XmlElement element) {
    return Det(
      nItem: element.getAttribute('nItem')!,
      prod: Prod.fromXml(element.findElements('prod').first),
      imposto: Imposto.fromXml(element.findElements('imposto').first),
      infAdProd: element.findElements('infAdProd').isNotEmpty
          ? InfAdProd.fromXml(element.findElements('infAdProd').first)
          : null,
    );
  }
}

/// Produto
class Prod {
  final String cProd;
  final String cEAN;
  final String xProd;
  final String ncm;
  final String? cest;
  final String cfop;
  final String uCom;
  final String qCom;
  final String vUnCom;
  final String vProd;
  final String cEANTrib;
  final String uTrib;
  final String qTrib;
  final String vUnTrib;
  final String? indTot; // 0=Não, 1=Sim (compõe total)

  Prod({
    required this.cProd,
    required this.cEAN,
    required this.xProd,
    required this.ncm,
    this.cest,
    required this.cfop,
    required this.uCom,
    required this.qCom,
    required this.vUnCom,
    required this.vProd,
    required this.cEANTrib,
    required this.uTrib,
    required this.qTrib,
    required this.vUnTrib,
    this.indTot,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'prod',
      nest: () {
        builder.element('cProd', nest: cProd);
        builder.element('cEAN', nest: cEAN);
        builder.element('xProd', nest: xProd);
        builder.element('NCM', nest: ncm);
        if (cest != null) builder.element('CEST', nest: cest);
        builder.element('CFOP', nest: cfop);
        builder.element('uCom', nest: uCom);
        builder.element('qCom', nest: qCom);
        builder.element('vUnCom', nest: vUnCom);
        builder.element('vProd', nest: vProd);
        builder.element('cEANTrib', nest: cEANTrib);
        builder.element('uTrib', nest: uTrib);
        builder.element('qTrib', nest: qTrib);
        builder.element('vUnTrib', nest: vUnTrib);
        if (indTot != null) builder.element('indTot', nest: indTot);
      },
    );
  }

  factory Prod.fromXml(XmlElement element) {
    return Prod(
      cProd: element.findElements('cProd').first.innerText,
      cEAN: element.findElements('cEAN').first.innerText,
      xProd: element.findElements('xProd').first.innerText,
      ncm: element.findElements('NCM').first.innerText,
      cest: element.findElements('CEST').isNotEmpty
          ? element.findElements('CEST').first.innerText
          : null,
      cfop: element.findElements('CFOP').first.innerText,
      uCom: element.findElements('uCom').first.innerText,
      qCom: element.findElements('qCom').first.innerText,
      vUnCom: element.findElements('vUnCom').first.innerText,
      vProd: element.findElements('vProd').first.innerText,
      cEANTrib: element.findElements('cEANTrib').first.innerText,
      uTrib: element.findElements('uTrib').first.innerText,
      qTrib: element.findElements('qTrib').first.innerText,
      vUnTrib: element.findElements('vUnTrib').first.innerText,
      indTot: element.findElements('indTot').isNotEmpty
          ? element.findElements('indTot').first.innerText
          : null,
    );
  }
}

/// Impostos do produto
class Imposto {
  final String? vTotTrib;
  final Icms icms;
  final Pis pis;
  final Cofins cofins;

  Imposto({
    this.vTotTrib,
    required this.icms,
    required this.pis,
    required this.cofins,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'imposto',
      nest: () {
        if (vTotTrib != null) builder.element('vTotTrib', nest: vTotTrib);
        icms.buildXml(builder);
        pis.buildXml(builder);
        cofins.buildXml(builder);
      },
    );
  }

  factory Imposto.fromXml(XmlElement element) {
    return Imposto(
      vTotTrib: element.findElements('vTotTrib').isNotEmpty
          ? element.findElements('vTotTrib').first.innerText
          : null,
      icms: Icms.fromXml(element.findElements('ICMS').first),
      pis: Pis.fromXml(element.findElements('PIS').first),
      cofins: Cofins.fromXml(element.findElements('COFINS').first),
    );
  }
}

/// ICMS (Simplificado - só ICMSSN102 para exemplo)
class Icms {
  final String cst; // Código situação tributária
  final String orig; // Origem mercadoria

  Icms({required this.cst, required this.orig});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ICMS',
      nest: () {
        builder.element(
          'ICMSSN102',
          nest: () {
            builder.element('orig', nest: orig);
            builder.element('CSOSN', nest: cst);
          },
        );
      },
    );
  }

  factory Icms.fromXml(XmlElement element) {
    final icmssn = element.findElements('ICMSSN102').first;
    return Icms(
      orig: icmssn.findElements('orig').first.innerText,
      cst: icmssn.findElements('CSOSN').first.innerText,
    );
  }
}

/// PIS
class Pis {
  final String cst;

  Pis({required this.cst});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'PIS',
      nest: () {
        builder.element(
          'PISOutr',
          nest: () {
            builder.element('CST', nest: cst);
            builder.element('vBC', nest: '0.00');
            builder.element('pPIS', nest: '0.00');
            builder.element('vPIS', nest: '0.00');
          },
        );
      },
    );
  }

  factory Pis.fromXml(XmlElement element) {
    final pisOutr = element.findElements('PISOutr').first;
    return Pis(cst: pisOutr.findElements('CST').first.innerText);
  }
}

/// COFINS
class Cofins {
  final String cst;

  Cofins({required this.cst});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'COFINS',
      nest: () {
        builder.element(
          'COFINSOutr',
          nest: () {
            builder.element('CST', nest: cst);
            builder.element('vBC', nest: '0.00');
            builder.element('pCOFINS', nest: '0.00');
            builder.element('vCOFINS', nest: '0.00');
          },
        );
      },
    );
  }

  factory Cofins.fromXml(XmlElement element) {
    final cofinsOutr = element.findElements('COFINSOutr').first;
    return Cofins(cst: cofinsOutr.findElements('CST').first.innerText);
  }
}

/// Informações adicionais do produto
class InfAdProd {
  final String infAdProd;

  InfAdProd(this.infAdProd);

  void buildXml(XmlBuilder builder) {
    builder.element('infAdProd', nest: infAdProd);
  }

  factory InfAdProd.fromXml(XmlElement element) {
    return InfAdProd(element.innerText);
  }
}
