import 'package:xml/xml.dart';
import 'retorno_sefaz_base.dart';

/// Protocolo de autorização individual de uma NFC-e.
class ProtNFe {
  final String chNFe;
  final String nProt;
  final String dhRecbto;
  final int cStat;
  final String xMotivo;
  final String digVal;

  const ProtNFe({
    required this.chNFe,
    required this.nProt,
    required this.dhRecbto,
    required this.cStat,
    required this.xMotivo,
    required this.digVal,
  });

  bool get autorizado => cStat == 100;
  bool get denegado => cStat == 110;
}

/// Resposta do serviço NfceAutorizacao4 / NfceRetAutorizacao4.
class RetornoAutorizacao extends RetornoSefazBase {
  /// Número de lote processado.
  final String? nRec;

  /// Protocolos de autorização por chave de acesso.
  final List<ProtNFe> protocolos;

  const RetornoAutorizacao({
    required super.cStat,
    required super.xMotivo,
    required super.cUF,
    required super.dhRecbto,
    required super.verAplic,
    this.nRec,
    required this.protocolos,
  });

  /// Retorna o protocolo para a chave de acesso informada, ou `null` se não encontrado.
  ProtNFe? protocolo(String chNFe) =>
      protocolos.where((p) => p.chNFe == chNFe).firstOrNull;

  factory RetornoAutorizacao.fromSoapXml(String soapXml) {
    final doc = XmlDocument.parse(soapXml);
    final ret = doc.findAllElements('retEnviNFe').first;

    String t(XmlElement el, String tag) =>
        el.findElements(tag).isNotEmpty ? el.findElements(tag).first.innerText : '';

    final protos = ret.findAllElements('protNFe').map((p) {
      final inf = p.findElements('infProt').first;
      return ProtNFe(
        chNFe: t(inf, 'chNFe'),
        nProt: t(inf, 'nProt'),
        dhRecbto: t(inf, 'dhRecbto'),
        cStat: int.tryParse(t(inf, 'cStat')) ?? -1,
        xMotivo: t(inf, 'xMotivo'),
        digVal: t(inf, 'digVal'),
      );
    }).toList();

    return RetornoAutorizacao(
      cStat: int.tryParse(t(ret, 'cStat')) ?? -1,
      xMotivo: t(ret, 'xMotivo'),
      cUF: t(ret, 'cUF'),
      dhRecbto: t(ret, 'dhRecbto'),
      verAplic: t(ret, 'verAplic'),
      nRec: ret.findElements('nRec').isNotEmpty ? t(ret, 'nRec') : null,
      protocolos: protos,
    );
  }
}
