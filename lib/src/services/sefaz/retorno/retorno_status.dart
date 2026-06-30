import 'package:xml/xml.dart';
import 'retorno_sefaz_base.dart';

/// Resposta do serviço NFeStatusServico4.
class RetornoStatus extends RetornoSefazBase {
  /// Tempo médio de resposta em segundos (quando fornecido).
  final String? tMed;

  const RetornoStatus({
    required super.cStat,
    required super.xMotivo,
    required super.cUF,
    required super.dhRecbto,
    required super.verAplic,
    this.tMed,
  });

  /// Serviço operacional: cStat 107.
  bool get emOperacao => cStat == 107;

  factory RetornoStatus.fromSoapXml(String soapXml) {
    final doc = XmlDocument.parse(soapXml);
    final ret = doc.findAllElements('retConsStatServ').first;

    String t(String tag) =>
        ret.findElements(tag).isNotEmpty ? ret.findElements(tag).first.innerText : '';

    return RetornoStatus(
      cStat: int.tryParse(t('cStat')) ?? -1,
      xMotivo: t('xMotivo'),
      cUF: t('cUF'),
      dhRecbto: t('dhRecbto'),
      verAplic: t('verAplic'),
      tMed: ret.findElements('tMed').isNotEmpty ? t('tMed') : null,
    );
  }
}
