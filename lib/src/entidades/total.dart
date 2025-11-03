import 'package:xml/xml.dart';

/// Totalizadores da NF-e
class Total {
  final IcmsTot icmsTot;

  Total({required this.icmsTot});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'total',
      nest: () {
        icmsTot.buildXml(builder);
      },
    );
  }

  factory Total.fromXml(XmlElement element) {
    return Total(
      icmsTot: IcmsTot.fromXml(element.findElements('ICMSTot').first),
    );
  }
}

/// Totalizadores ICMS
class IcmsTot {
  final String vBC;
  final String vICMS;
  final String vICMSDeson;
  final String vFCP;
  final String vBCST;
  final String vST;
  final String vFCPST;
  final String vFCPSTRet;
  final String vProd;
  final String vFrete;
  final String vSeg;
  final String vDesc;
  final String vII;
  final String vIPI;
  final String vIPIDevol;
  final String vPIS;
  final String vCOFINS;
  final String vOutro;
  final String vNF;
  final String? vTotTrib;

  IcmsTot({
    required this.vBC,
    required this.vICMS,
    required this.vICMSDeson,
    required this.vFCP,
    required this.vBCST,
    required this.vST,
    required this.vFCPST,
    required this.vFCPSTRet,
    required this.vProd,
    required this.vFrete,
    required this.vSeg,
    required this.vDesc,
    required this.vII,
    required this.vIPI,
    required this.vIPIDevol,
    required this.vPIS,
    required this.vCOFINS,
    required this.vOutro,
    required this.vNF,
    this.vTotTrib,
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'ICMSTot',
      nest: () {
        builder.element('vBC', nest: vBC);
        builder.element('vICMS', nest: vICMS);
        builder.element('vICMSDeson', nest: vICMSDeson);
        builder.element('vFCP', nest: vFCP);
        builder.element('vBCST', nest: vBCST);
        builder.element('vST', nest: vST);
        builder.element('vFCPST', nest: vFCPST);
        builder.element('vFCPSTRet', nest: vFCPSTRet);
        builder.element('vProd', nest: vProd);
        builder.element('vFrete', nest: vFrete);
        builder.element('vSeg', nest: vSeg);
        builder.element('vDesc', nest: vDesc);
        builder.element('vII', nest: vII);
        builder.element('vIPI', nest: vIPI);
        builder.element('vIPIDevol', nest: vIPIDevol);
        builder.element('vPIS', nest: vPIS);
        builder.element('vCOFINS', nest: vCOFINS);
        builder.element('vOutro', nest: vOutro);
        builder.element('vNF', nest: vNF);
        if (vTotTrib != null) builder.element('vTotTrib', nest: vTotTrib);
      },
    );
  }

  factory IcmsTot.fromXml(XmlElement element) {
    return IcmsTot(
      vBC: element.findElements('vBC').first.innerText,
      vICMS: element.findElements('vICMS').first.innerText,
      vICMSDeson: element.findElements('vICMSDeson').first.innerText,
      vFCP: element.findElements('vFCP').first.innerText,
      vBCST: element.findElements('vBCST').first.innerText,
      vST: element.findElements('vST').first.innerText,
      vFCPST: element.findElements('vFCPST').first.innerText,
      vFCPSTRet: element.findElements('vFCPSTRet').first.innerText,
      vProd: element.findElements('vProd').first.innerText,
      vFrete: element.findElements('vFrete').first.innerText,
      vSeg: element.findElements('vSeg').first.innerText,
      vDesc: element.findElements('vDesc').first.innerText,
      vII: element.findElements('vII').first.innerText,
      vIPI: element.findElements('vIPI').first.innerText,
      vIPIDevol: element.findElements('vIPIDevol').first.innerText,
      vPIS: element.findElements('vPIS').first.innerText,
      vCOFINS: element.findElements('vCOFINS').first.innerText,
      vOutro: element.findElements('vOutro').first.innerText,
      vNF: element.findElements('vNF').first.innerText,
      vTotTrib: element.findElements('vTotTrib').isNotEmpty
          ? element.findElements('vTotTrib').first.innerText
          : null,
    );
  }
}
