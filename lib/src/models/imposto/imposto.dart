import 'package:xml/xml.dart';
import 'package:dfe_dart/src/models/imposto/icms.dart';
import 'package:dfe_dart/src/models/imposto/pis.dart';
import 'package:dfe_dart/src/models/imposto/cofins.dart';

class ImpostoModel {
  final Icms icms;
  final Pis pis;
  final Cofins cofins;
  final double? vTotTrib;

  ImpostoModel({
    required this.icms,
    required this.pis,
    required this.cofins,
    this.vTotTrib,
  });

  void writeXml(XmlBuilder builder) {
    builder.element('imposto', nest: () {
      if (vTotTrib != null) {
        builder.element('vTotTrib', nest: vTotTrib!.toStringAsFixed(2));
      }
      builder.xml(icms.writeXml().toXmlString());
      builder.xml(pis.writeXml().toXmlString());
      builder.xml(cofins.writeXml().toXmlString());
    });
  }

  static ImpostoModel fromXml(XmlElement element) {
    final vTotTribText = element.getElement('vTotTrib')?.innerText;

    final icmsEl = element.getElement('ICMS');
    if (icmsEl == null) throw ArgumentError('Missing <ICMS> element in <imposto>');

    final pisEl = element.getElement('PIS');
    if (pisEl == null) throw ArgumentError('Missing <PIS> element in <imposto>');

    return ImpostoModel(
      vTotTrib: vTotTribText != null ? double.parse(vTotTribText) : null,
      icms: Icms.fromXml(icmsEl),
      pis: Pis.fromXml(pisEl),
      cofins: Cofins.fromXml(element),
    );
  }
}
