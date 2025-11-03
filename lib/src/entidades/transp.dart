import 'package:xml/xml.dart';

/// Transporte
class Transp {
  final String modFrete; // 9=Sem frete (para NFC-e)

  Transp({required this.modFrete});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'transp',
      nest: () {
        builder.element('modFrete', nest: modFrete);
      },
    );
  }

  factory Transp.fromXml(XmlElement element) {
    return Transp(modFrete: element.findElements('modFrete').first.innerText);
  }
}
