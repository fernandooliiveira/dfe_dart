import 'package:xml/xml.dart';
import 'package:dfe_dart/src/models/prod.dart';
import 'package:dfe_dart/src/models/imposto/imposto.dart';

/// Represents a NF-e line item (det element).
class DetModel {
  /// Item number starting at 1.
  final int nItem;

  /// Product/service data.
  final ProdModel prod;

  /// Tax data.
  final ImpostoModel imposto;

  /// Additional product information (optional, max 500 chars).
  final String? infAdProd;

  const DetModel({
    required this.nItem,
    required this.prod,
    required this.imposto,
    this.infAdProd,
  });

  void writeXml(XmlBuilder builder) {
    builder.element('det', attributes: {'nItem': nItem.toString()}, nest: () {
      prod.writeXml(builder);
      imposto.writeXml(builder);
      if (infAdProd != null) {
        builder.element('infAdProd', nest: () {
          builder.text(infAdProd!);
        });
      }
    });
  }

  static DetModel fromXml(XmlElement element) {
    final nItem = int.parse(element.getAttribute('nItem') ?? '0');

    final prodElement = element.getElement('prod');
    if (prodElement == null) {
      throw ArgumentError('Missing <prod> element in <det>');
    }

    final impostoElement = element.getElement('imposto');
    if (impostoElement == null) {
      throw ArgumentError('Missing <imposto> element in <det>');
    }

    final infAdProd = element.getElement('infAdProd')?.innerText;

    return DetModel(
      nItem: nItem,
      prod: ProdModel.fromXml(prodElement),
      imposto: ImpostoModel.fromXml(impostoElement),
      infAdProd: infAdProd,
    );
  }
}
