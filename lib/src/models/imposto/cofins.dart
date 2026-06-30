import 'package:xml/xml.dart';

/// Sealed base class representing the COFINS group in NF-e 4.00.
sealed class Cofins {
  const Cofins();

  /// Serializes this COFINS variant to its corresponding [XmlElement].
  XmlElement writeXml();

  /// Deserializes the [cofinsElement] (the `<COFINS>` wrapper element) into
  /// the appropriate [Cofins] subclass based on which child element is present.
  static Cofins fromXml(XmlElement cofinsElement) {
    if (cofinsElement.getElement('COFINSAliq') != null) {
      return CofinsAliq.fromXml(cofinsElement.getElement('COFINSAliq')!);
    }
    if (cofinsElement.getElement('COFINSQtde') != null) {
      return CofinsQtde.fromXml(cofinsElement.getElement('COFINSQtde')!);
    }
    if (cofinsElement.getElement('COFINSNT') != null) {
      return CofinsNt.fromXml(cofinsElement.getElement('COFINSNT')!);
    }
    if (cofinsElement.getElement('COFINSOutr') != null) {
      return CofinsOutr.fromXml(cofinsElement.getElement('COFINSOutr')!);
    }
    if (cofinsElement.getElement('COFINSSN') != null) {
      return CofinsSn.fromXml(cofinsElement.getElement('COFINSSN')!);
    }
    throw ArgumentError(
      'Unknown COFINS variant in element: ${cofinsElement.toXmlString()}',
    );
  }
}

/// CST 01/02 — COFINS com alíquota ad valorem.
///
/// XML element: `<COFINSAliq>`
final class CofinsAliq extends Cofins {
  /// Código de Situação Tributária da COFINS (01 ou 02).
  final String cst;

  /// Base de cálculo da COFINS (vBC).
  final double vBc;

  /// Alíquota da COFINS em percentual (pCOFINS).
  final double pCofins;

  /// Valor da COFINS (vCOFINS).
  final double vCofins;

  const CofinsAliq({
    required this.cst,
    required this.vBc,
    required this.pCofins,
    required this.vCofins,
  });

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('COFINSAliq', nest: () {
      builder.element('CST', nest: cst);
      builder.element('vBC', nest: vBc.toStringAsFixed(2));
      builder.element('pCOFINS', nest: pCofins.toStringAsFixed(4));
      builder.element('vCOFINS', nest: vCofins.toStringAsFixed(2));
    });
    return builder.buildDocument().rootElement.copy();
  }

  static CofinsAliq fromXml(XmlElement element) {
    double dbl(String tag) =>
        double.tryParse(element.getElement(tag)?.innerText ?? '') ?? 0.0;

    return CofinsAliq(
      cst: element.getElement('CST')?.innerText ?? '',
      vBc: dbl('vBC'),
      pCofins: dbl('pCOFINS'),
      vCofins: dbl('vCOFINS'),
    );
  }
}

/// CST 03 — COFINS por quantidade (alíquota específica).
///
/// XML element: `<COFINSQtde>`
final class CofinsQtde extends Cofins {
  /// Código de Situação Tributária da COFINS (03).
  final String cst;

  /// Quantidade vendida (qBCProd).
  final double qBcProd;

  /// Alíquota da COFINS em reais (vAliqProd).
  final double vAliqProd;

  /// Valor da COFINS (vCOFINS).
  final double vCofins;

  const CofinsQtde({
    required this.cst,
    required this.qBcProd,
    required this.vAliqProd,
    required this.vCofins,
  });

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('COFINSQtde', nest: () {
      builder.element('CST', nest: cst);
      builder.element('qBCProd', nest: qBcProd.toStringAsFixed(4));
      builder.element('vAliqProd', nest: vAliqProd.toStringAsFixed(4));
      builder.element('vCOFINS', nest: vCofins.toStringAsFixed(2));
    });
    return builder.buildDocument().rootElement.copy();
  }

  static CofinsQtde fromXml(XmlElement element) {
    double dbl(String tag) =>
        double.tryParse(element.getElement(tag)?.innerText ?? '') ?? 0.0;

    return CofinsQtde(
      cst: element.getElement('CST')?.innerText ?? '',
      qBcProd: dbl('qBCProd'),
      vAliqProd: dbl('vAliqProd'),
      vCofins: dbl('vCOFINS'),
    );
  }
}

/// CST 04/06/07/08/09 — COFINS não tributada.
///
/// XML element: `<COFINSNT>`
final class CofinsNt extends Cofins {
  /// Código de Situação Tributária da COFINS (04, 06, 07, 08 ou 09).
  final String cst;

  const CofinsNt({required this.cst});

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('COFINSNT', nest: () {
      builder.element('CST', nest: cst);
    });
    return builder.buildDocument().rootElement.copy();
  }

  static CofinsNt fromXml(XmlElement element) {
    return CofinsNt(
      cst: element.getElement('CST')?.innerText ?? '',
    );
  }
}

/// CST 49/50/etc — Outras operações de COFINS.
///
/// XML element: `<COFINSOutr>`
final class CofinsOutr extends Cofins {
  /// Código de Situação Tributária da COFINS.
  final String cst;

  /// Base de cálculo da COFINS (vBC). Null quando a cobrança é por quantidade.
  final double? vBc;

  /// Alíquota da COFINS em percentual (pCOFINS). Null quando não se aplica.
  final double? pCofins;

  /// Quantidade vendida (qBCProd). Null quando a cobrança é ad valorem.
  final double? qBcProd;

  /// Alíquota da COFINS em reais (vAliqProd). Null quando não se aplica.
  final double? vAliqProd;

  /// Valor da COFINS (vCOFINS).
  final double vCofins;

  const CofinsOutr({
    required this.cst,
    this.vBc,
    this.pCofins,
    this.qBcProd,
    this.vAliqProd,
    required this.vCofins,
  });

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('COFINSOutr', nest: () {
      builder.element('CST', nest: cst);
      if (vBc != null) {
        builder.element('vBC', nest: vBc!.toStringAsFixed(2));
      }
      if (pCofins != null) {
        builder.element('pCOFINS', nest: pCofins!.toStringAsFixed(4));
      }
      if (qBcProd != null) {
        builder.element('qBCProd', nest: qBcProd!.toStringAsFixed(4));
      }
      if (vAliqProd != null) {
        builder.element('vAliqProd', nest: vAliqProd!.toStringAsFixed(4));
      }
      builder.element('vCOFINS', nest: vCofins.toStringAsFixed(2));
    });
    return builder.buildDocument().rootElement.copy();
  }

  static CofinsOutr fromXml(XmlElement element) {
    double? optionalDbl(String tag) {
      final val = element.getElement(tag)?.innerText;
      if (val == null) return null;
      return double.tryParse(val);
    }

    double dbl(String tag) =>
        double.tryParse(element.getElement(tag)?.innerText ?? '') ?? 0.0;

    return CofinsOutr(
      cst: element.getElement('CST')?.innerText ?? '',
      vBc: optionalDbl('vBC'),
      pCofins: optionalDbl('pCOFINS'),
      qBcProd: optionalDbl('qBCProd'),
      vAliqProd: optionalDbl('vAliqProd'),
      vCofins: dbl('vCOFINS'),
    );
  }
}

/// Simples Nacional — COFINS para contribuintes do Simples Nacional.
///
/// XML element: `<COFINSSN>`
final class CofinsSn extends Cofins {
  const CofinsSn();

  @override
  XmlElement writeXml() {
    final builder = XmlBuilder();
    builder.element('COFINSSN', nest: () {});
    return builder.buildDocument().rootElement.copy();
  }

  static CofinsSn fromXml(XmlElement element) {
    return const CofinsSn();
  }
}
