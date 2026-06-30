import 'package:xml/xml.dart';

sealed class Pis {
  XmlElement writeXml();

  static Pis fromXml(XmlElement pisElement) {
    final child = pisElement.childElements.first;
    switch (child.name.local) {
      case 'PISAliq':
        return PisAliq.fromXml(child);
      case 'PISQtde':
        return PisQtde.fromXml(child);
      case 'PISNT':
        return PisNt.fromXml(child);
      case 'PISOutr':
        return PisOutr.fromXml(child);
      case 'PISSN':
        return PisSn.fromXml(child);
      default:
        throw ArgumentError('Unknown PIS variant: ${child.name.local}');
    }
  }
}

class PisAliq extends Pis {
  final String cst;
  final double vBC;
  final double pPIS;
  final double vPIS;

  PisAliq({
    required this.cst,
    required this.vBC,
    required this.pPIS,
    required this.vPIS,
  });

  factory PisAliq.fromXml(XmlElement element) {
    return PisAliq(
      cst: element.findElements('CST').first.innerText,
      vBC: double.parse(element.findElements('vBC').first.innerText),
      pPIS: double.parse(element.findElements('pPIS').first.innerText),
      vPIS: double.parse(element.findElements('vPIS').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('PIS', nest: () {
      builder.element('PISAliq', nest: () {
        builder.element('CST', nest: cst);
        builder.element('vBC', nest: vBC.toStringAsFixed(2));
        builder.element('pPIS', nest: pPIS.toStringAsFixed(4));
        builder.element('vPIS', nest: vPIS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class PisQtde extends Pis {
  final String cst;
  final double qBCProd;
  final double vAliqProd;
  final double vPIS;

  PisQtde({
    this.cst = '03',
    required this.qBCProd,
    required this.vAliqProd,
    required this.vPIS,
  });

  factory PisQtde.fromXml(XmlElement element) {
    return PisQtde(
      cst: element.findElements('CST').first.innerText,
      qBCProd: double.parse(element.findElements('qBCProd').first.innerText),
      vAliqProd: double.parse(element.findElements('vAliqProd').first.innerText),
      vPIS: double.parse(element.findElements('vPIS').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('PIS', nest: () {
      builder.element('PISQtde', nest: () {
        builder.element('CST', nest: cst);
        builder.element('qBCProd', nest: qBCProd.toStringAsFixed(4));
        builder.element('vAliqProd', nest: vAliqProd.toStringAsFixed(4));
        builder.element('vPIS', nest: vPIS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class PisNt extends Pis {
  final String cst;

  PisNt({required this.cst});

  factory PisNt.fromXml(XmlElement element) {
    return PisNt(
      cst: element.findElements('CST').first.innerText,
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('PIS', nest: () {
      builder.element('PISNT', nest: () {
        builder.element('CST', nest: cst);
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class PisOutr extends Pis {
  final String cst;
  final double? vBC;
  final double? pPIS;
  final double? qBCProd;
  final double? vAliqProd;
  final double vPIS;

  PisOutr({
    required this.cst,
    this.vBC,
    this.pPIS,
    this.qBCProd,
    this.vAliqProd,
    required this.vPIS,
  });

  factory PisOutr.fromXml(XmlElement element) {
    double? parseOptional(String tag) {
      final els = element.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    return PisOutr(
      cst: element.findElements('CST').first.innerText,
      vBC: parseOptional('vBC'),
      pPIS: parseOptional('pPIS'),
      qBCProd: parseOptional('qBCProd'),
      vAliqProd: parseOptional('vAliqProd'),
      vPIS: double.parse(element.findElements('vPIS').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('PIS', nest: () {
      builder.element('PISOutr', nest: () {
        builder.element('CST', nest: cst);
        if (vBC != null) builder.element('vBC', nest: vBC!.toStringAsFixed(2));
        if (pPIS != null) builder.element('pPIS', nest: pPIS!.toStringAsFixed(4));
        if (qBCProd != null) builder.element('qBCProd', nest: qBCProd!.toStringAsFixed(4));
        if (vAliqProd != null) builder.element('vAliqProd', nest: vAliqProd!.toStringAsFixed(4));
        builder.element('vPIS', nest: vPIS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class PisSn extends Pis {
  final double vPIS;

  PisSn({this.vPIS = 0.00});

  factory PisSn.fromXml(XmlElement element) {
    final els = element.findElements('vPIS');
    return PisSn(
      vPIS: els.isNotEmpty ? double.parse(els.first.innerText) : 0.00,
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('PIS', nest: () {
      builder.element('PISSN', nest: () {
        builder.element('CST', nest: '49');
        builder.element('vPIS', nest: vPIS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}
