import 'package:xml/xml.dart';
import 'retorno_sefaz_base.dart';

/// Protocolo de inutilização de numeração.
class InfInut {
  final String tpAmb;
  final String verAplic;
  final String cStat;
  final String xMotivo;
  final String cUF;
  final String ano;
  final String cnpj;
  final String mod;
  final String serie;
  final String nNFIni;
  final String nNFFin;
  final String? nProt;
  final String? dhRecbto;

  const InfInut({
    required this.tpAmb,
    required this.verAplic,
    required this.cStat,
    required this.xMotivo,
    required this.cUF,
    required this.ano,
    required this.cnpj,
    required this.mod,
    required this.serie,
    required this.nNFIni,
    required this.nNFFin,
    this.nProt,
    this.dhRecbto,
  });

  bool get inutilizado => int.tryParse(cStat) == 102;
}

/// Resposta do serviço NFeInutilizacao4.
class RetornoInutilizacao extends RetornoSefazBase {
  final InfInut? infInut;

  const RetornoInutilizacao({
    required super.cStat,
    required super.xMotivo,
    required super.cUF,
    required super.dhRecbto,
    required super.verAplic,
    this.infInut,
  });

  bool get inutilizado => cStat == 102;

  factory RetornoInutilizacao.fromSoapXml(String soapXml) {
    final doc = XmlDocument.parse(soapXml);
    final ret = doc.findAllElements('retInutNFe').first;

    String t(XmlElement el, String tag) =>
        el.findElements(tag).isNotEmpty ? el.findElements(tag).first.innerText : '';

    final infEl = ret.findAllElements('infInut').firstOrNull;
    InfInut? inf;
    if (infEl != null) {
      inf = InfInut(
        tpAmb: t(infEl, 'tpAmb'),
        verAplic: t(infEl, 'verAplic'),
        cStat: t(infEl, 'cStat'),
        xMotivo: t(infEl, 'xMotivo'),
        cUF: t(infEl, 'cUF'),
        ano: t(infEl, 'ano'),
        cnpj: t(infEl, 'CNPJ'),
        mod: t(infEl, 'mod'),
        serie: t(infEl, 'serie'),
        nNFIni: t(infEl, 'nNFIni'),
        nNFFin: t(infEl, 'nNFFin'),
        nProt: infEl.findElements('nProt').isNotEmpty ? t(infEl, 'nProt') : null,
        dhRecbto: infEl.findElements('dhRecbto').isNotEmpty ? t(infEl, 'dhRecbto') : null,
      );
    }

    // cStat/xMotivo no nível do retInutNFe caem dentro do infInut na spec 4.00,
    // então normalizamos para a base usando os valores do infInut quando disponível.
    final cStatFinal = int.tryParse(t(ret, 'cStat').isNotEmpty ? t(ret, 'cStat') : (inf?.cStat ?? '-1')) ?? -1;

    return RetornoInutilizacao(
      cStat: cStatFinal != -1 ? cStatFinal : (int.tryParse(inf?.cStat ?? '') ?? -1),
      xMotivo: t(ret, 'xMotivo').isNotEmpty ? t(ret, 'xMotivo') : (inf?.xMotivo ?? ''),
      cUF: t(ret, 'cUF').isNotEmpty ? t(ret, 'cUF') : (inf?.cUF ?? ''),
      dhRecbto: t(ret, 'dhRecbto').isNotEmpty ? t(ret, 'dhRecbto') : (inf?.dhRecbto ?? ''),
      verAplic: t(ret, 'verAplic').isNotEmpty ? t(ret, 'verAplic') : (inf?.verAplic ?? ''),
      infInut: inf,
    );
  }
}
