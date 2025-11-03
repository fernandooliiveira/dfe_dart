import 'package:xml/xml.dart';

/// Pagamento
class Pag {
  final List<DetPag> detPag;

  Pag({required this.detPag});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'pag',
      nest: () {
        for (final det in detPag) {
          det.buildXml(builder);
        }
      },
    );
  }

  factory Pag.fromXml(XmlElement element) {
    return Pag(
      detPag: element
          .findElements('detPag')
          .map((e) => DetPag.fromXml(e))
          .toList(),
    );
  }
}

/// Detalhe do pagamento
class DetPag {
  final String indPag; // 0=À vista, 1=À prazo
  final String tPag; // 01=Dinheiro, 03=Cartão de Crédito, etc.
  final String vPag;

  DetPag({required this.indPag, required this.tPag, required this.vPag});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'detPag',
      nest: () {
        builder.element('indPag', nest: indPag);
        builder.element('tPag', nest: tPag);
        builder.element('vPag', nest: vPag);
      },
    );
  }

  factory DetPag.fromXml(XmlElement element) {
    return DetPag(
      indPag: element.findElements('indPag').first.innerText,
      tPag: element.findElements('tPag').first.innerText,
      vPag: element.findElements('vPag').first.innerText,
    );
  }
}
