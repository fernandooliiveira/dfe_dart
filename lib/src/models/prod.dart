import 'package:xml/xml.dart';

class ProdModel {
  final String cProd;
  final String cEAN;
  final String xProd;
  final String ncm;
  final String? cBenef;
  final String? exTIPI;
  final String cfop;
  final String uCom;
  final double qCom;
  final double vUnCom;
  final double vProd;
  final String cEANTrib;
  final String uTrib;
  final double qTrib;
  final double vUnTrib;
  final double? vFrete;
  final double? vSeg;
  final double? vDesc;
  final double? vOutro;
  final int indTot;

  const ProdModel({
    required this.cProd,
    required this.cEAN,
    required this.xProd,
    required this.ncm,
    this.cBenef,
    this.exTIPI,
    required this.cfop,
    required this.uCom,
    required this.qCom,
    required this.vUnCom,
    required this.vProd,
    required this.cEANTrib,
    required this.uTrib,
    required this.qTrib,
    required this.vUnTrib,
    this.vFrete,
    this.vSeg,
    this.vDesc,
    this.vOutro,
    required this.indTot,
  });

  void writeXml(XmlBuilder builder) {
    builder.element('prod', nest: () {
      builder.element('cProd', nest: cProd);
      builder.element('cEAN', nest: cEAN);
      builder.element('xProd', nest: xProd);
      builder.element('NCM', nest: ncm);
      if (cBenef != null) {
        builder.element('cBenef', nest: cBenef!);
      }
      if (exTIPI != null) {
        builder.element('EXTIPI', nest: exTIPI!);
      }
      builder.element('CFOP', nest: cfop);
      builder.element('uCom', nest: uCom);
      builder.element('qCom', nest: qCom.toStringAsFixed(10));
      builder.element('vUnCom', nest: vUnCom.toStringAsFixed(10));
      builder.element('vProd', nest: vProd.toStringAsFixed(2));
      builder.element('cEANTrib', nest: cEANTrib);
      builder.element('uTrib', nest: uTrib);
      builder.element('qTrib', nest: qTrib.toStringAsFixed(10));
      builder.element('vUnTrib', nest: vUnTrib.toStringAsFixed(10));
      if (vFrete != null) {
        builder.element('vFrete', nest: vFrete!.toStringAsFixed(2));
      }
      if (vSeg != null) {
        builder.element('vSeg', nest: vSeg!.toStringAsFixed(2));
      }
      if (vDesc != null) {
        builder.element('vDesc', nest: vDesc!.toStringAsFixed(2));
      }
      if (vOutro != null) {
        builder.element('vOutro', nest: vOutro!.toStringAsFixed(2));
      }
      builder.element('indTot', nest: indTot.toString());
    });
  }

  static ProdModel fromXml(XmlElement element) {
    String text(String tag) =>
        element.getElement(tag)?.innerText ?? '';

    String? optionalText(String tag) =>
        element.getElement(tag)?.innerText;

    double dbl(String tag) =>
        double.tryParse(element.getElement(tag)?.innerText ?? '') ?? 0.0;

    double? optionalDbl(String tag) {
      final val = element.getElement(tag)?.innerText;
      if (val == null) return null;
      return double.tryParse(val);
    }

    return ProdModel(
      cProd: text('cProd'),
      cEAN: text('cEAN'),
      xProd: text('xProd'),
      ncm: text('NCM'),
      cBenef: optionalText('cBenef'),
      exTIPI: optionalText('EXTIPI'),
      cfop: text('CFOP'),
      uCom: text('uCom'),
      qCom: dbl('qCom'),
      vUnCom: dbl('vUnCom'),
      vProd: dbl('vProd'),
      cEANTrib: text('cEANTrib'),
      uTrib: text('uTrib'),
      qTrib: dbl('qTrib'),
      vUnTrib: dbl('vUnTrib'),
      vFrete: optionalDbl('vFrete'),
      vSeg: optionalDbl('vSeg'),
      vDesc: optionalDbl('vDesc'),
      vOutro: optionalDbl('vOutro'),
      indTot: int.tryParse(element.getElement('indTot')?.innerText ?? '1') ?? 1,
    );
  }
}
