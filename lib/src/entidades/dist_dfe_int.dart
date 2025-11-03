import 'package:xml/xml.dart';

/// Requisicao de distribuicao de documentos fiscais (DF-e).
class DistDFeInt {
  final String versao;
  final String tpAmb;
  final String cUFAutor;
  final String? cnpj;
  final String? cpf;
  final DistNSU? distNSU;
  final ConsNSU? consNSU;
  final ConsChNFe? consChNFe;

  DistDFeInt({
    this.versao = '1.01',
    required this.tpAmb,
    required this.cUFAutor,
    this.cnpj,
    this.cpf,
    this.distNSU,
    this.consNSU,
    this.consChNFe,
  }) : assert(cnpj != null || cpf != null, 'Informe CNPJ ou CPF.'),
       assert(
         (distNSU != null ? 1 : 0) +
                 (consNSU != null ? 1 : 0) +
                 (consChNFe != null ? 1 : 0) ==
             1,
         'Informe exatamente um filtro: distNSU, consNSU ou consChNFe.',
       );

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'distDFeInt',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('cUFAutor', nest: cUFAutor);
        if (cnpj != null) {
          builder.element('CNPJ', nest: cnpj);
        } else if (cpf != null) {
          builder.element('CPF', nest: cpf);
        }
        distNSU?.buildXml(builder);
        consNSU?.buildXml(builder);
        consChNFe?.buildXml(builder);
      },
    );
  }

  factory DistDFeInt.fromDocument(XmlDocument doc) {
    return DistDFeInt.fromXml(doc.rootElement);
  }

  factory DistDFeInt.fromXml(XmlElement element) {
    String? _text(String tag) {
      final nodes = element.findElements(tag);
      return nodes.isNotEmpty ? nodes.first.innerText : null;
    }

    DistNSU? _findDistNSU() {
      final node = element.findElements('distNSU');
      return node.isNotEmpty ? DistNSU.fromXml(node.first) : null;
    }

    ConsNSU? _findConsNSU() {
      final node = element.findElements('consNSU');
      return node.isNotEmpty ? ConsNSU.fromXml(node.first) : null;
    }

    ConsChNFe? _findConsChNFe() {
      final node = element.findElements('consChNFe');
      return node.isNotEmpty ? ConsChNFe.fromXml(node.first) : null;
    }

    return DistDFeInt(
      versao: element.getAttribute('versao') ?? '1.01',
      tpAmb: element.findElements('tpAmb').first.innerText,
      cUFAutor: element.findElements('cUFAutor').first.innerText,
      cnpj: _text('CNPJ'),
      cpf: _text('CPF'),
      distNSU: _findDistNSU(),
      consNSU: _findConsNSU(),
      consChNFe: _findConsChNFe(),
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}

class DistNSU {
  final String ultNSU;

  DistNSU({required this.ultNSU});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'distNSU',
      nest: () {
        builder.element('ultNSU', nest: ultNSU);
      },
    );
  }

  factory DistNSU.fromXml(XmlElement element) {
    return DistNSU(ultNSU: element.findElements('ultNSU').first.innerText);
  }
}

class ConsNSU {
  final String nsu;

  ConsNSU({required this.nsu});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'consNSU',
      nest: () {
        builder.element('NSU', nest: nsu);
      },
    );
  }

  factory ConsNSU.fromXml(XmlElement element) {
    return ConsNSU(nsu: element.findElements('NSU').first.innerText);
  }
}

class ConsChNFe {
  final String chNFe;

  ConsChNFe({required this.chNFe});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'consChNFe',
      nest: () {
        builder.element('chNFe', nest: chNFe);
      },
    );
  }

  factory ConsChNFe.fromXml(XmlElement element) {
    return ConsChNFe(chNFe: element.findElements('chNFe').first.innerText);
  }
}
