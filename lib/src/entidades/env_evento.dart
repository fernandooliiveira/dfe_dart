import 'package:xml/xml.dart';
import 'package:xml_sign_dart/src/entidades/signature.dart';

/// Lote de eventos (cancelamento, carta de correcao, manifesto, etc.).
class EnvEvento {
  final String versao;
  final String idLote;
  final List<Evento> eventos;

  EnvEvento({
    this.versao = '1.00',
    required this.idLote,
    required List<Evento> eventos,
  }) : eventos = List.unmodifiable(eventos),
       assert(eventos.isNotEmpty, 'Informe ao menos um evento.');

  XmlDocument toXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    buildXml(builder);
    return builder.buildDocument();
  }

  void buildXml(XmlBuilder builder) {
    builder.element(
      'envEvento',
      nest: () {
        builder.attribute('xmlns', 'http://www.portalfiscal.inf.br/nfe');
        builder.attribute('versao', versao);
        builder.element('idLote', nest: idLote);
        for (final evento in eventos) {
          evento.buildXml(builder);
        }
      },
    );
  }

  factory EnvEvento.fromDocument(XmlDocument doc) {
    return EnvEvento.fromXml(doc.rootElement);
  }

  factory EnvEvento.fromXml(XmlElement element) {
    final eventos = element.findElements('evento').map(Evento.fromXml).toList();
    return EnvEvento(
      versao: element.getAttribute('versao') ?? '1.00',
      idLote: element.findElements('idLote').first.innerText,
      eventos: eventos,
    );
  }

  String toXmlString({bool pretty = false}) =>
      toXml().toXmlString(pretty: pretty);

  @override
  String toString() => toXmlString(pretty: true);
}

class Evento {
  final String versao;
  final InfEvento infEvento;
  final Signature? signature;

  Evento({this.versao = '1.00', required this.infEvento, this.signature});

  void buildXml(XmlBuilder builder) {
    builder.element(
      'evento',
      nest: () {
        builder.attribute('versao', versao);
        infEvento.buildXml(builder);
        if (signature != null) {
          signature!.buildXml(builder);
        }
      },
    );
  }

  factory Evento.fromXml(XmlElement element) {
    final infEvento = element.findElements('infEvento').first;
    return Evento(
      versao: element.getAttribute('versao') ?? '1.00',
      infEvento: InfEvento.fromXml(infEvento),
      signature: element.findElements('Signature').isNotEmpty
          ? Signature.fromXml(element.findElements('Signature').first)
          : null,
    );
  }
}

class InfEvento {
  final String id;
  final String cOrgao;
  final String tpAmb;
  final String? cnpj;
  final String? cpf;
  final String chNFe;
  final String dhEvento;
  final String tpEvento;
  final String nSeqEvento;
  final String verEvento;
  final List<EventoCampo> camposAdicionais;
  final DetEvento detEvento;

  InfEvento({
    required this.id,
    required this.cOrgao,
    required this.tpAmb,
    this.cnpj,
    this.cpf,
    required this.chNFe,
    required this.dhEvento,
    required this.tpEvento,
    required this.nSeqEvento,
    required this.verEvento,
    this.camposAdicionais = const [],
    required this.detEvento,
  }) : assert(cnpj != null || cpf != null, 'Informe CNPJ ou CPF.');

  void buildXml(XmlBuilder builder) {
    builder.element(
      'infEvento',
      nest: () {
        builder.attribute('Id', id);
        builder.element('cOrgao', nest: cOrgao);
        builder.element('tpAmb', nest: tpAmb);
        if (cnpj != null) {
          builder.element('CNPJ', nest: cnpj);
        } else if (cpf != null) {
          builder.element('CPF', nest: cpf);
        }
        builder.element('chNFe', nest: chNFe);
        builder.element('dhEvento', nest: dhEvento);
        builder.element('tpEvento', nest: tpEvento);
        builder.element('nSeqEvento', nest: nSeqEvento);
        builder.element('verEvento', nest: verEvento);
        for (final campo in camposAdicionais) {
          campo.buildXml(builder);
        }
        detEvento.buildXml(builder);
      },
    );
  }

  factory InfEvento.fromXml(XmlElement element) {
    EventoCampo _mapCampo(XmlElement e) =>
        EventoCampo(tag: e.name.local, valor: e.innerText);

    final conhecidos = <String>{
      'cOrgao',
      'tpAmb',
      'CNPJ',
      'CPF',
      'chNFe',
      'dhEvento',
      'tpEvento',
      'nSeqEvento',
      'verEvento',
      'detEvento',
    };

    final camposExtras = element.children
        .whereType<XmlElement>()
        .where((e) => !conhecidos.contains(e.name.local))
        .map(_mapCampo)
        .toList();

    String? _texto(String tag) {
      final encontrados = element.findElements(tag);
      return encontrados.isNotEmpty ? encontrados.first.innerText : null;
    }

    return InfEvento(
      id: element.getAttribute('Id') ?? '',
      cOrgao: element.findElements('cOrgao').first.innerText,
      tpAmb: element.findElements('tpAmb').first.innerText,
      cnpj: _texto('CNPJ'),
      cpf: _texto('CPF'),
      chNFe: element.findElements('chNFe').first.innerText,
      dhEvento: element.findElements('dhEvento').first.innerText,
      tpEvento: element.findElements('tpEvento').first.innerText,
      nSeqEvento: element.findElements('nSeqEvento').first.innerText,
      verEvento: element.findElements('verEvento').first.innerText,
      camposAdicionais: camposExtras,
      detEvento: DetEvento.fromXml(element.findElements('detEvento').first),
    );
  }
}

class DetEvento {
  final String versao;
  final String descEvento;
  final List<EventoCampo> campos;

  DetEvento({
    this.versao = '1.00',
    required this.descEvento,
    this.campos = const [],
  });

  void buildXml(XmlBuilder builder) {
    builder.element(
      'detEvento',
      nest: () {
        builder.attribute('versao', versao);
        builder.element('descEvento', nest: descEvento);
        for (final campo in campos) {
          campo.buildXml(builder);
        }
      },
    );
  }

  factory DetEvento.fromXml(XmlElement element) {
    EventoCampo _mapCampo(XmlElement e) =>
        EventoCampo(tag: e.name.local, valor: e.innerText);

    final campos = element.children
        .whereType<XmlElement>()
        .where((e) => e.name.local != 'descEvento')
        .map(_mapCampo)
        .toList();

    return DetEvento(
      versao: element.getAttribute('versao') ?? '1.00',
      descEvento: element.findElements('descEvento').first.innerText,
      campos: campos,
    );
  }
}

class EventoCampo {
  final String tag;
  final String? valor;
  final List<EventoCampo> filhos;

  const EventoCampo({required this.tag, this.valor, this.filhos = const []});

  void buildXml(XmlBuilder builder) {
    if (valor == null && filhos.isEmpty) {
      throw StateError('Elemento $tag requer valor ou filhos.');
    }

    if (filhos.isEmpty) {
      builder.element(tag, nest: valor ?? '');
      return;
    }

    builder.element(
      tag,
      nest: () {
        if (valor != null) {
          builder.text(valor!);
        }
        for (final filho in filhos) {
          filho.buildXml(builder);
        }
      },
    );
  }
}
