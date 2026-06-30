import 'package:xml/xml.dart';
import 'retorno_sefaz_base.dart';

/// Resultado individual de um evento (cancelamento, CC-e etc.).
class InfRetEvento {
  final String chNFe;
  final String tpEvento;
  final String nSeqEvento;
  final int cStat;
  final String xMotivo;
  final String? nProt;
  final String dhRegEvento;

  const InfRetEvento({
    required this.chNFe,
    required this.tpEvento,
    required this.nSeqEvento,
    required this.cStat,
    required this.xMotivo,
    this.nProt,
    required this.dhRegEvento,
  });

  bool get registrado => cStat == 135 || cStat == 136;
}

/// Resposta do serviço NFeRecepcaoEvento4.
class RetornoEvento extends RetornoSefazBase {
  final List<InfRetEvento> eventos;

  const RetornoEvento({
    required super.cStat,
    required super.xMotivo,
    required super.cUF,
    required super.dhRecbto,
    required super.verAplic,
    required this.eventos,
  });

  factory RetornoEvento.fromSoapXml(String soapXml) {
    final doc = XmlDocument.parse(soapXml);
    final ret = doc.findAllElements('retEnvEvento').first;

    String t(XmlElement el, String tag) =>
        el.findElements(tag).isNotEmpty ? el.findElements(tag).first.innerText : '';

    final evts = ret.findAllElements('retEvento').map((re) {
      final inf = re.findElements('infEvento').first;
      return InfRetEvento(
        chNFe: t(inf, 'chNFe'),
        tpEvento: t(inf, 'tpEvento'),
        nSeqEvento: t(inf, 'nSeqEvento'),
        cStat: int.tryParse(t(inf, 'cStat')) ?? -1,
        xMotivo: t(inf, 'xMotivo'),
        nProt: inf.findElements('nProt').isNotEmpty ? t(inf, 'nProt') : null,
        dhRegEvento: t(inf, 'dhRegEvento'),
      );
    }).toList();

    return RetornoEvento(
      cStat: int.tryParse(t(ret, 'cStat')) ?? -1,
      xMotivo: t(ret, 'xMotivo'),
      cUF: t(ret, 'cUF'),
      dhRecbto: t(ret, 'dhRecbto'),
      verAplic: t(ret, 'verAplic'),
      eventos: evts,
    );
  }
}
