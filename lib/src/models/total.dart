import 'package:xml/xml.dart';

class ICMSTotModel {
  final double vBC;
  final double vICMS;
  final double vICMSDeson;
  final double? vFCPUFDest;
  final double? vICMSUFDest;
  final double? vICMSUFRemet;
  final double? vFCP;
  final double vBCST;
  final double vST;
  final double? vFCPST;
  final double? vFCPSTRet;
  final double vProd;
  final double vFrete;
  final double vSeg;
  final double vDesc;
  final double? vII;
  final double? vIPI;
  final double? vIPIDevol;
  final double vPIS;
  final double vCOFINS;
  final double vOutro;
  final double vNF;
  final double? vTotTrib;

  ICMSTotModel({
    required this.vBC,
    required this.vICMS,
    required this.vICMSDeson,
    this.vFCPUFDest,
    this.vICMSUFDest,
    this.vICMSUFRemet,
    this.vFCP,
    required this.vBCST,
    required this.vST,
    this.vFCPST,
    this.vFCPSTRet,
    required this.vProd,
    required this.vFrete,
    required this.vSeg,
    required this.vDesc,
    this.vII,
    this.vIPI,
    this.vIPIDevol,
    required this.vPIS,
    required this.vCOFINS,
    required this.vOutro,
    required this.vNF,
    this.vTotTrib,
  });

  void writeXml(XmlBuilder builder) {
    builder.element('ICMSTot', nest: () {
      builder.element('vBC', nest: vBC.toStringAsFixed(2));
      builder.element('vICMS', nest: vICMS.toStringAsFixed(2));
      builder.element('vICMSDeson', nest: vICMSDeson.toStringAsFixed(2));
      if (vFCPUFDest != null) {
        builder.element('vFCPUFDest', nest: vFCPUFDest!.toStringAsFixed(2));
      }
      if (vICMSUFDest != null) {
        builder.element('vICMSUFDest', nest: vICMSUFDest!.toStringAsFixed(2));
      }
      if (vICMSUFRemet != null) {
        builder.element('vICMSUFRemet', nest: vICMSUFRemet!.toStringAsFixed(2));
      }
      if (vFCP != null) {
        builder.element('vFCP', nest: vFCP!.toStringAsFixed(2));
      }
      builder.element('vBCST', nest: vBCST.toStringAsFixed(2));
      builder.element('vST', nest: vST.toStringAsFixed(2));
      if (vFCPST != null) {
        builder.element('vFCPST', nest: vFCPST!.toStringAsFixed(2));
      }
      if (vFCPSTRet != null) {
        builder.element('vFCPSTRet', nest: vFCPSTRet!.toStringAsFixed(2));
      }
      builder.element('vProd', nest: vProd.toStringAsFixed(2));
      builder.element('vFrete', nest: vFrete.toStringAsFixed(2));
      builder.element('vSeg', nest: vSeg.toStringAsFixed(2));
      builder.element('vDesc', nest: vDesc.toStringAsFixed(2));
      if (vII != null) {
        builder.element('vII', nest: vII!.toStringAsFixed(2));
      }
      if (vIPI != null) {
        builder.element('vIPI', nest: vIPI!.toStringAsFixed(2));
      }
      if (vIPIDevol != null) {
        builder.element('vIPIDevol', nest: vIPIDevol!.toStringAsFixed(2));
      }
      builder.element('vPIS', nest: vPIS.toStringAsFixed(2));
      builder.element('vCOFINS', nest: vCOFINS.toStringAsFixed(2));
      builder.element('vOutro', nest: vOutro.toStringAsFixed(2));
      builder.element('vNF', nest: vNF.toStringAsFixed(2));
      if (vTotTrib != null) {
        builder.element('vTotTrib', nest: vTotTrib!.toStringAsFixed(2));
      }
    });
  }

  static ICMSTotModel fromXml(XmlElement element) {
    double getDouble(String tag) =>
        double.parse(element.findElements(tag).first.innerText);

    double? getOptionalDouble(String tag) {
      final elements = element.findElements(tag);
      if (elements.isEmpty) return null;
      return double.parse(elements.first.innerText);
    }

    return ICMSTotModel(
      vBC: getDouble('vBC'),
      vICMS: getDouble('vICMS'),
      vICMSDeson: getDouble('vICMSDeson'),
      vFCPUFDest: getOptionalDouble('vFCPUFDest'),
      vICMSUFDest: getOptionalDouble('vICMSUFDest'),
      vICMSUFRemet: getOptionalDouble('vICMSUFRemet'),
      vFCP: getOptionalDouble('vFCP'),
      vBCST: getDouble('vBCST'),
      vST: getDouble('vST'),
      vFCPST: getOptionalDouble('vFCPST'),
      vFCPSTRet: getOptionalDouble('vFCPSTRet'),
      vProd: getDouble('vProd'),
      vFrete: getDouble('vFrete'),
      vSeg: getDouble('vSeg'),
      vDesc: getDouble('vDesc'),
      vII: getOptionalDouble('vII'),
      vIPI: getOptionalDouble('vIPI'),
      vIPIDevol: getOptionalDouble('vIPIDevol'),
      vPIS: getDouble('vPIS'),
      vCOFINS: getDouble('vCOFINS'),
      vOutro: getDouble('vOutro'),
      vNF: getDouble('vNF'),
      vTotTrib: getOptionalDouble('vTotTrib'),
    );
  }
}

class TotalModel {
  final ICMSTotModel icmsTot;

  TotalModel({required this.icmsTot});

  void writeXml(XmlBuilder builder) {
    builder.element('total', nest: () {
      icmsTot.writeXml(builder);
    });
  }

  static TotalModel fromXml(XmlElement element) {
    final icmsTotElement = element.findElements('ICMSTot').first;
    return TotalModel(
      icmsTot: ICMSTotModel.fromXml(icmsTotElement),
    );
  }
}
