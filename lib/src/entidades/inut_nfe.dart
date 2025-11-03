import 'package:xml/xml.dart';
import 'package:xml_sign_dart/src/entidades/signature.dart';

/// Pedido de inutilizacao de numeracao.
class InutNFe {
  final String versao;
  final InfInut infInut;
  final Signature? signature;

  InutNFe({this.versao = '4.00', required this.infInut, this.signature});

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'inutNFe',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        infInut.buildXml(builder);
        if (signature != null) {
          signature!.buildXml(builder);
        }
      },
    );
  }

  factory InutNFe.fromDocument(XmlDocument doc) {
    return InutNFe.fromXml(doc.rootElement);
  }

  factory InutNFe.fromXml(XmlElement element) {
    final infInutElement = element.findElements('infInut').first;
    return InutNFe(
      versao: element.getAttribute('versao') ?? '4.00',
      infInut: InfInut.fromXml(infInutElement),
      signature: element.findElements('Signature').isNotEmpty
          ? Signature.fromXml(element.findElements('Signature').first)
          : null,
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}

class InfInut {
  final String id;
  final String tpAmb;
  final String xServ;
  final String cUF;
  final String ano;
  final String? cnpj;
  final String? cpf;
  final String mod;
  final String serie;
  final String nNFIni;
  final String nNFFin;
  final String xJust;

  InfInut({
    required this.id,
    required this.tpAmb,
    this.xServ = 'INUTILIZAR',
    required this.cUF,
    required this.ano,
    this.cnpj,
    this.cpf,
    required this.mod,
    required this.serie,
    required this.nNFIni,
    required this.nNFFin,
    required this.xJust,
  }) : assert(cnpj != null || cpf != null, 'Informe CNPJ ou CPF.');

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infInut',
      nest: () {
        builder.attribute('Id', id);
        builder.element('tpAmb', nest: tpAmb);
        builder.element('xServ', nest: xServ);
        builder.element('cUF', nest: cUF);
        builder.element('ano', nest: ano);
        if (cnpj != null) {
          builder.element('CNPJ', nest: cnpj);
        } else if (cpf != null) {
          builder.element('CPF', nest: cpf);
        }
        builder.element('mod', nest: mod);
        builder.element('serie', nest: serie);
        builder.element('nNFIni', nest: nNFIni);
        builder.element('nNFFin', nest: nNFFin);
        builder.element('xJust', nest: xJust);
      },
    );
  }

  factory InfInut.fromXml(XmlElement element) {
    String? _textOrNull(String tag) {
      final found = element.findElements(tag);
      return found.isNotEmpty ? found.first.innerText : null;
    }

    return InfInut(
      id: element.getAttribute('Id') ?? '',
      tpAmb: element.findElements('tpAmb').first.innerText,
      xServ: element.findElements('xServ').first.innerText,
      cUF: element.findElements('cUF').first.innerText,
      ano: element.findElements('ano').first.innerText,
      cnpj: _textOrNull('CNPJ'),
      cpf: _textOrNull('CPF'),
      mod: element.findElements('mod').first.innerText,
      serie: element.findElements('serie').first.innerText,
      nNFIni: element.findElements('nNFIni').first.innerText,
      nNFFin: element.findElements('nNFFin').first.innerText,
      xJust: element.findElements('xJust').first.innerText,
    );
  }
}
