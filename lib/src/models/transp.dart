import 'package:xml/xml.dart';
import 'package:dfe_dart/src/enum/_init.dart';

class TranspModel {
  final EModalidadeFrete modFrete;

  const TranspModel({
    required this.modFrete,
  });

  void writeXml(XmlBuilder builder) {
    builder.element('transp', nest: () {
      builder.element('modFrete', nest: modFrete.xmlValue);
    });
  }

  static TranspModel fromXml(XmlElement element) {
    final modFreteText = element.findElements('modFrete').first.innerText;
    return TranspModel(
      modFrete: EModalidadeFrete.values.firstWhere(
        (e) => e.xmlValue == modFreteText,
      ),
    );
  }
}
