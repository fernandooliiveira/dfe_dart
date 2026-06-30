import 'package:dfe_dart/src/enum/_init.dart';
import 'package:xml/xml.dart';

class DetPagModel {
  EFormaPagamento tPag;
  double vPag;
  int? indPag;
  int? tpIntegra;
  String? cnpj;
  String? tBand;
  String? cAut;

  DetPagModel({
    required this.tPag,
    required this.vPag,
    this.indPag,
    this.tpIntegra,
    this.cnpj,
    this.tBand,
    this.cAut,
  });

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('detPag', nest: () {
      if (indPag != null) builder.element('indPag', nest: indPag.toString());
      builder.element('tPag', nest: tPag.xmlValue);
      builder.element('vPag', nest: vPag.toStringAsFixed(2));
      if (tpIntegra != null) builder.element('tpIntegra', nest: tpIntegra.toString());
      if (cnpj != null) builder.element('CNPJ', nest: cnpj!);
      if (tBand != null) builder.element('tBand', nest: tBand!);
      if (cAut != null) builder.element('cAut', nest: cAut!);
    });
    return builder.buildDocument().rootElement;
  }

  static DetPagModel fromXml(XmlElement element) {
    String? text(String tag) {
      final els = element.findElements(tag);
      return els.isEmpty ? null : els.single.innerText;
    }

    String req(String tag) => element.findElements(tag).single.innerText;

    return DetPagModel(
      tPag: EFormaPagamento.values.firstWhere((e) => e.xmlValue == req('tPag')),
      vPag: double.parse(req('vPag')),
      indPag: () {
        final v = text('indPag');
        return v == null ? null : int.parse(v);
      }(),
      tpIntegra: () {
        final v = text('tpIntegra');
        return v == null ? null : int.parse(v);
      }(),
      cnpj: text('CNPJ'),
      tBand: text('tBand'),
      cAut: text('cAut'),
    );
  }
}

class PagModel {
  List<DetPagModel> detPag;
  double? vTroco;

  PagModel({
    required this.detPag,
    this.vTroco,
  }) : assert(detPag.isNotEmpty, 'detPag must have at least one element');

  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('pag', nest: () {
      for (final det in detPag) {
        builder.xml(det.writeXml().toXmlString());
      }
      if (vTroco != null) builder.element('vTroco', nest: vTroco!.toStringAsFixed(2));
    });
    return builder.buildDocument().rootElement;
  }

  static PagModel fromXml(XmlElement element) {
    final detPagEls = element.findElements('detPag').toList();
    final detPagList = detPagEls.map((e) => DetPagModel.fromXml(e)).toList();

    final vTrocoEls = element.findElements('vTroco');
    final vTroco = vTrocoEls.isEmpty ? null : double.parse(vTrocoEls.single.innerText);

    return PagModel(
      detPag: detPagList,
      vTroco: vTroco,
    );
  }
}
