import 'package:xml/xml.dart';

sealed class Icms {
  XmlElement writeXml();

  static Icms fromXml(XmlElement icmsElement) {
    final child = icmsElement.childElements.first;
    return switch (child.name.local) {
      'ICMS00' => Icms00.fromXml(child),
      'ICMS10' => Icms10.fromXml(child),
      'ICMS20' => Icms20.fromXml(child),
      'ICMS40' => Icms40.fromXml(child),
      'ICMS60' => Icms60.fromXml(child),
      'ICMS90' => Icms90.fromXml(child),
      'ICMSSN102' => IcmsSn102.fromXml(child),
      'ICMSSN500' => IcmsSn500.fromXml(child),
      'ICMSSN900' => IcmsSn900.fromXml(child),
      _ => throw ArgumentError('Unknown ICMS variant: ${child.name.local}'),
    };
  }
}

class Icms00 extends Icms {
  final String orig;
  final String cst;
  final String modBC;
  final double vBC;
  final double pICMS;
  final double vICMS;

  Icms00({
    required this.orig,
    required this.cst,
    required this.modBC,
    required this.vBC,
    required this.pICMS,
    required this.vICMS,
  });

  factory Icms00.fromXml(XmlElement e) {
    return Icms00(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
      modBC: e.findElements('modBC').first.innerText,
      vBC: double.parse(e.findElements('vBC').first.innerText),
      pICMS: double.parse(e.findElements('pICMS').first.innerText),
      vICMS: double.parse(e.findElements('vICMS').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS00', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
        builder.element('modBC', nest: modBC);
        builder.element('vBC', nest: vBC.toStringAsFixed(2));
        builder.element('pICMS', nest: pICMS.toStringAsFixed(4));
        builder.element('vICMS', nest: vICMS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class Icms10 extends Icms {
  final String orig;
  final String cst;
  final String modBC;
  final double vBC;
  final double pICMS;
  final double vICMS;
  final String modBCST;
  final double? pMVAST;
  final double? pRedBCST;
  final double vBCST;
  final double pICMSST;
  final double vICMSST;

  Icms10({
    required this.orig,
    required this.cst,
    required this.modBC,
    required this.vBC,
    required this.pICMS,
    required this.vICMS,
    required this.modBCST,
    this.pMVAST,
    this.pRedBCST,
    required this.vBCST,
    required this.pICMSST,
    required this.vICMSST,
  });

  factory Icms10.fromXml(XmlElement e) {
    double? opt(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    return Icms10(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
      modBC: e.findElements('modBC').first.innerText,
      vBC: double.parse(e.findElements('vBC').first.innerText),
      pICMS: double.parse(e.findElements('pICMS').first.innerText),
      vICMS: double.parse(e.findElements('vICMS').first.innerText),
      modBCST: e.findElements('modBCST').first.innerText,
      pMVAST: opt('pMVAST'),
      pRedBCST: opt('pRedBCST'),
      vBCST: double.parse(e.findElements('vBCST').first.innerText),
      pICMSST: double.parse(e.findElements('pICMSST').first.innerText),
      vICMSST: double.parse(e.findElements('vICMSST').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS10', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
        builder.element('modBC', nest: modBC);
        builder.element('vBC', nest: vBC.toStringAsFixed(2));
        builder.element('pICMS', nest: pICMS.toStringAsFixed(4));
        builder.element('vICMS', nest: vICMS.toStringAsFixed(2));
        builder.element('modBCST', nest: modBCST);
        if (pMVAST != null) builder.element('pMVAST', nest: pMVAST!.toStringAsFixed(4));
        if (pRedBCST != null) builder.element('pRedBCST', nest: pRedBCST!.toStringAsFixed(4));
        builder.element('vBCST', nest: vBCST.toStringAsFixed(2));
        builder.element('pICMSST', nest: pICMSST.toStringAsFixed(4));
        builder.element('vICMSST', nest: vICMSST.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class Icms20 extends Icms {
  final String orig;
  final String cst;
  final String modBC;
  final double pRedBC;
  final double vBC;
  final double pICMS;
  final double vICMS;

  Icms20({
    required this.orig,
    required this.cst,
    required this.modBC,
    required this.pRedBC,
    required this.vBC,
    required this.pICMS,
    required this.vICMS,
  });

  factory Icms20.fromXml(XmlElement e) {
    return Icms20(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
      modBC: e.findElements('modBC').first.innerText,
      pRedBC: double.parse(e.findElements('pRedBC').first.innerText),
      vBC: double.parse(e.findElements('vBC').first.innerText),
      pICMS: double.parse(e.findElements('pICMS').first.innerText),
      vICMS: double.parse(e.findElements('vICMS').first.innerText),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS20', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
        builder.element('modBC', nest: modBC);
        builder.element('pRedBC', nest: pRedBC.toStringAsFixed(4));
        builder.element('vBC', nest: vBC.toStringAsFixed(2));
        builder.element('pICMS', nest: pICMS.toStringAsFixed(4));
        builder.element('vICMS', nest: vICMS.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class Icms40 extends Icms {
  final String orig;
  final String cst;

  Icms40({required this.orig, required this.cst});

  factory Icms40.fromXml(XmlElement e) {
    return Icms40(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS40', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class Icms60 extends Icms {
  final String orig;
  final String cst;
  final double? vBCSTRet;
  final double? pST;
  final double? vICMSSTRet;

  Icms60({
    required this.orig,
    required this.cst,
    this.vBCSTRet,
    this.pST,
    this.vICMSSTRet,
  });

  factory Icms60.fromXml(XmlElement e) {
    double? opt(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    return Icms60(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
      vBCSTRet: opt('vBCSTRet'),
      pST: opt('pST'),
      vICMSSTRet: opt('vICMSSTRet'),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS60', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
        if (vBCSTRet != null) builder.element('vBCSTRet', nest: vBCSTRet!.toStringAsFixed(2));
        if (pST != null) builder.element('pST', nest: pST!.toStringAsFixed(4));
        if (vICMSSTRet != null) builder.element('vICMSSTRet', nest: vICMSSTRet!.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class Icms90 extends Icms {
  final String orig;
  final String cst;
  final String? modBC;
  final double? vBC;
  final double? pRedBC;
  final double? pICMS;
  final double? vICMS;
  final String? modBCST;
  final double? vBCST;
  final double? pICMSST;
  final double? vICMSST;

  Icms90({
    required this.orig,
    required this.cst,
    this.modBC,
    this.vBC,
    this.pRedBC,
    this.pICMS,
    this.vICMS,
    this.modBCST,
    this.vBCST,
    this.pICMSST,
    this.vICMSST,
  });

  factory Icms90.fromXml(XmlElement e) {
    double? opt(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    String? optStr(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? els.first.innerText : null;
    }

    return Icms90(
      orig: e.findElements('orig').first.innerText,
      cst: e.findElements('CST').first.innerText,
      modBC: optStr('modBC'),
      vBC: opt('vBC'),
      pRedBC: opt('pRedBC'),
      pICMS: opt('pICMS'),
      vICMS: opt('vICMS'),
      modBCST: optStr('modBCST'),
      vBCST: opt('vBCST'),
      pICMSST: opt('pICMSST'),
      vICMSST: opt('vICMSST'),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMS90', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CST', nest: cst);
        if (modBC != null) builder.element('modBC', nest: modBC!);
        if (vBC != null) builder.element('vBC', nest: vBC!.toStringAsFixed(2));
        if (pRedBC != null) builder.element('pRedBC', nest: pRedBC!.toStringAsFixed(4));
        if (pICMS != null) builder.element('pICMS', nest: pICMS!.toStringAsFixed(4));
        if (vICMS != null) builder.element('vICMS', nest: vICMS!.toStringAsFixed(2));
        if (modBCST != null) builder.element('modBCST', nest: modBCST!);
        if (vBCST != null) builder.element('vBCST', nest: vBCST!.toStringAsFixed(2));
        if (pICMSST != null) builder.element('pICMSST', nest: pICMSST!.toStringAsFixed(4));
        if (vICMSST != null) builder.element('vICMSST', nest: vICMSST!.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class IcmsSn102 extends Icms {
  final String orig;
  final String csosn;

  IcmsSn102({required this.orig, required this.csosn});

  factory IcmsSn102.fromXml(XmlElement e) {
    return IcmsSn102(
      orig: e.findElements('orig').first.innerText,
      csosn: e.findElements('CSOSN').first.innerText,
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMSSN102', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CSOSN', nest: csosn);
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class IcmsSn500 extends Icms {
  final String orig;
  final String csosn;
  final double? vBCSTRet;
  final double? pST;
  final double? vICMSSTRet;

  IcmsSn500({
    required this.orig,
    required this.csosn,
    this.vBCSTRet,
    this.pST,
    this.vICMSSTRet,
  });

  factory IcmsSn500.fromXml(XmlElement e) {
    double? opt(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    return IcmsSn500(
      orig: e.findElements('orig').first.innerText,
      csosn: e.findElements('CSOSN').first.innerText,
      vBCSTRet: opt('vBCSTRet'),
      pST: opt('pST'),
      vICMSSTRet: opt('vICMSSTRet'),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMSSN500', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CSOSN', nest: csosn);
        if (vBCSTRet != null) builder.element('vBCSTRet', nest: vBCSTRet!.toStringAsFixed(2));
        if (pST != null) builder.element('pST', nest: pST!.toStringAsFixed(4));
        if (vICMSSTRet != null) builder.element('vICMSSTRet', nest: vICMSSTRet!.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}

class IcmsSn900 extends Icms {
  final String orig;
  final String csosn;
  final String? modBC;
  final double? vBC;
  final double? pRedBC;
  final double? pICMS;
  final double? vICMS;
  final String? modBCST;
  final double? vBCST;
  final double? pICMSST;
  final double? vICMSST;

  IcmsSn900({
    required this.orig,
    required this.csosn,
    this.modBC,
    this.vBC,
    this.pRedBC,
    this.pICMS,
    this.vICMS,
    this.modBCST,
    this.vBCST,
    this.pICMSST,
    this.vICMSST,
  });

  factory IcmsSn900.fromXml(XmlElement e) {
    double? opt(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? double.parse(els.first.innerText) : null;
    }

    String? optStr(String tag) {
      final els = e.findElements(tag);
      return els.isNotEmpty ? els.first.innerText : null;
    }

    return IcmsSn900(
      orig: e.findElements('orig').first.innerText,
      csosn: e.findElements('CSOSN').first.innerText,
      modBC: optStr('modBC'),
      vBC: opt('vBC'),
      pRedBC: opt('pRedBC'),
      pICMS: opt('pICMS'),
      vICMS: opt('vICMS'),
      modBCST: optStr('modBCST'),
      vBCST: opt('vBCST'),
      pICMSST: opt('pICMSST'),
      vICMSST: opt('vICMSST'),
    );
  }

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('ICMS', nest: () {
      builder.element('ICMSSN900', nest: () {
        builder.element('orig', nest: orig);
        builder.element('CSOSN', nest: csosn);
        if (modBC != null) builder.element('modBC', nest: modBC!);
        if (vBC != null) builder.element('vBC', nest: vBC!.toStringAsFixed(2));
        if (pRedBC != null) builder.element('pRedBC', nest: pRedBC!.toStringAsFixed(4));
        if (pICMS != null) builder.element('pICMS', nest: pICMS!.toStringAsFixed(4));
        if (vICMS != null) builder.element('vICMS', nest: vICMS!.toStringAsFixed(2));
        if (modBCST != null) builder.element('modBCST', nest: modBCST!);
        if (vBCST != null) builder.element('vBCST', nest: vBCST!.toStringAsFixed(2));
        if (pICMSST != null) builder.element('pICMSST', nest: pICMSST!.toStringAsFixed(4));
        if (vICMSST != null) builder.element('vICMSST', nest: vICMSST!.toStringAsFixed(2));
      });
    });
    return builder.buildDocument().rootElement.copy();
  }
}
