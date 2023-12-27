import 'package:xml/xml.dart';

class InfNFeSupl {
  String? qrCode;
  String? urlChave;

  void readXml(XmlElement element) {
    qrCode = element.findElements('qrCode').single.value;

    var urlChaveElements = element.findElements('urlChave');
    if (urlChaveElements.isNotEmpty) {
      urlChave = urlChaveElements.single.value;
    }
  }

  XmlElement writeXml() {
    var builder = XmlBuilder();
    builder.element('infNFeSupl', nest: () {
      if(qrCode != null) {
        builder.element('qrCode', nest: () {
          builder.text(qrCode!);
        });
      }

      if (urlChave != null) {
        builder.element('urlChave', nest: () {
          builder.text(urlChave!);
        });
      }
    });

    return builder.buildDocument().rootElement;
  }
}

