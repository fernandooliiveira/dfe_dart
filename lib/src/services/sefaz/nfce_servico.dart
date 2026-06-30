import 'dart:typed_data';

import 'package:xml/xml.dart';

import '../../enum/estado.dart';
import '../../enum/tipo_ambiente.dart';
import '../assinador_xml.dart';
import 'endereco_sefaz.dart';
import 'retorno/retorno_autorizacao.dart';
import 'retorno/retorno_evento.dart';
import 'retorno/retorno_inutilizacao.dart';
import 'retorno/retorno_status.dart';
import 'sefaz_client.dart';
import 'soap_builder.dart';
import 'tipo_servico_sefaz.dart';

/// Serviço de alto nível para comunicação com a SEFAZ (NFC-e 4.00).
///
/// Uso:
/// ```dart
/// final servico = NfceServico.fromPfx(
///   pfxBytes: File('cert.pfx').readAsBytesSync(),
///   senha: 'senha123',
///   estado: EEstado.sp,
///   ambiente: ETipoAmbiente.homologacao,
/// );
///
/// // Verificar se SEFAZ está online
/// final status = await servico.consultarStatus();
/// print(status.emOperacao); // true
///
/// // Autorizar NFC-e
/// final ret = await servico.autorizar(xmlAssinado);
/// final prot = ret.protocolo(chNFe);
/// print(prot?.nProt); // número do protocolo
///
/// servico.close();
/// ```
class NfceServico {
  final SefazClient _client;
  final AssinadorXml _assinador;
  final EEstado _estado;
  final ETipoAmbiente _ambiente;

  NfceServico._({
    required SefazClient client,
    required AssinadorXml assinador,
    required EEstado estado,
    required ETipoAmbiente ambiente,
  })  : _client = client,
        _assinador = assinador,
        _estado = estado,
        _ambiente = ambiente;

  /// Cria o serviço a partir de um arquivo PFX/P12.
  factory NfceServico.fromPfx({
    required Uint8List pfxBytes,
    required String senha,
    required EEstado estado,
    required ETipoAmbiente ambiente,
  }) {
    final parsed = AssinadorXml.parsePfx(pfxBytes, senha);
    final client = SefazClient.fromPkcs12(parsed.pkcs8Der, parsed.certDer);
    final assinador = AssinadorXml.forTesting(parsed.privateKey, parsed.certDer);
    return NfceServico._(
      client: client,
      assinador: assinador,
      estado: estado,
      ambiente: ambiente,
    );
  }

  // ─── Status do Serviço ────────────────────────────────────────────────────

  /// Consulta o status do WebService da SEFAZ.
  ///
  /// Retorna [RetornoStatus] com `emOperacao == true` quando `cStat == 107`.
  Future<RetornoStatus> consultarStatus() async {
    final url = _url(ETipoServicoSefaz.nfeStatusServico);
    final envelope = SoapBuilder.statusServico(
      cUF: _estado.codigo,
      tpAmb: _ambiente.xmlValue,
    );
    final resp = await _client.post(url, envelope);
    return RetornoStatus.fromSoapXml(resp);
  }

  // ─── Autorização ──────────────────────────────────────────────────────────

  /// Envia uma NFC-e para autorização.
  ///
  /// Aceita tanto XML já assinado quanto XML não assinado (assina automaticamente).
  /// Usa modo síncrono (`indSinc=1`), que é obrigatório para NFC-e.
  Future<RetornoAutorizacao> autorizar(
    String xmlNfe, {
    String? idLote,
  }) async {
    // Assina se ainda não houver <Signature>
    final xml = _isAssinado(xmlNfe) ? xmlNfe : _assinador.assinar(xmlNfe);

    final url = _url(ETipoServicoSefaz.nfceAutorizacao);
    final envelope = SoapBuilder.autorizacao(
      xmlNfeAssinado: xml,
      cUF: _estado.codigo,
      tpAmb: _ambiente.xmlValue,
      idLote: idLote ?? _loteId(),
    );
    final resp = await _client.post(url, envelope);
    return RetornoAutorizacao.fromSoapXml(resp);
  }

  // ─── Cancelamento ─────────────────────────────────────────────────────────

  /// Envia um evento de cancelamento para a NFC-e indicada.
  ///
  /// [chNFe]    chave de acesso (44 dígitos).
  /// [nProt]    número do protocolo de autorização.
  /// [xJust]    justificativa (min. 15 chars).
  /// [cnpjEmit] CNPJ do emitente (só dígitos).
  Future<RetornoEvento> cancelar({
    required String chNFe,
    required String nProt,
    required String xJust,
    required String cnpjEmit,
    String nSeqEvento = '1',
  }) async {
    if (xJust.trim().length < 15) {
      throw ArgumentError('xJust deve ter no mínimo 15 caracteres.');
    }

    final dhEvento = DateTime.now().toIso8601String();
    final idEvento = 'ID110111${chNFe}01';

    // Monta o XML do evento (infEvento sem assinatura)
    final infEventoXml = '<infEvento Id="$idEvento">'
        '<cOrgao>${_estado.codigo}</cOrgao>'
        '<tpAmb>${_ambiente.xmlValue}</tpAmb>'
        '<CNPJ>$cnpjEmit</CNPJ>'
        '<chNFe>$chNFe</chNFe>'
        '<dhEvento>$dhEvento</dhEvento>'
        '<tpEvento>110111</tpEvento>'
        '<nSeqEvento>$nSeqEvento</nSeqEvento>'
        '<verEvento>1.00</verEvento>'
        '<detEvento versao="1.00">'
        '<descEvento>Cancelamento</descEvento>'
        '<nProt>$nProt</nProt>'
        '<xJust>$xJust</xJust>'
        '</detEvento>'
        '</infEvento>';

    final eventoXml =
        '<evento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
        '$infEventoXml'
        '</evento>';

    // Assina o evento
    final eventoAssinado = _assinarElemento(eventoXml, idEvento);

    final envEventoXml =
        '<envEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
        '<idLote>${_loteId()}</idLote>'
        '$eventoAssinado'
        '</envEvento>';

    final url = _url(ETipoServicoSefaz.nfeRecepcaoEvento);
    final envelope = SoapBuilder.recepcaoEvento(
      xmlEventoAssinado: envEventoXml,
      cUF: _estado.codigo,
      tpAmb: _ambiente.xmlValue,
    );
    final resp = await _client.post(url, envelope);
    return RetornoEvento.fromSoapXml(resp);
  }

  // ─── Consulta de Protocolo ────────────────────────────────────────────────

  // ─── Inutilização ─────────────────────────────────────────────────────────

  /// Inutiliza uma faixa de numeração de NFC-e.
  ///
  /// [cnpjEmit]  CNPJ do emitente (só dígitos).
  /// [serie]     série da NFC-e (ex.: '001').
  /// [nNFIni]    primeiro número a inutilizar.
  /// [nNFFin]    último número a inutilizar.
  /// [xJust]     justificativa (min. 15 chars).
  /// [ano]       ano de 2 dígitos (ex.: '24'); padrão = ano atual.
  Future<RetornoInutilizacao> inutilizar({
    required String cnpjEmit,
    required String serie,
    required String nNFIni,
    required String nNFFin,
    required String xJust,
    String? ano,
  }) async {
    if (xJust.trim().length < 15) {
      throw ArgumentError('xJust deve ter no mínimo 15 caracteres.');
    }

    final anoVal = ano ?? DateTime.now().year.toString().substring(2);
    final cUF = _estado.codigo;
    // Id = cUF + ano + CNPJ + mod + serie + nNFIni + nNFFin (formato da spec)
    final id = 'ID$cUF$anoVal${cnpjEmit}65${serie.padLeft(3, '0')}'
        '${nNFIni.padLeft(9, '0')}${nNFFin.padLeft(9, '0')}';

    final infInutXml = '<infInut Id="$id">'
        '<tpAmb>${_ambiente.xmlValue}</tpAmb>'
        '<xServ>INUTILIZAR</xServ>'
        '<cUF>$cUF</cUF>'
        '<ano>$anoVal</ano>'
        '<CNPJ>$cnpjEmit</CNPJ>'
        '<mod>65</mod>'
        '<serie>${serie.padLeft(3, '0')}</serie>'
        '<nNFIni>${nNFIni.padLeft(9, '0')}</nNFIni>'
        '<nNFFin>${nNFFin.padLeft(9, '0')}</nNFFin>'
        '<xJust>$xJust</xJust>'
        '</infInut>';

    final inutXml =
        '<inutNFe versao="4.00" xmlns="http://www.portalfiscal.inf.br/nfe">'
        '$infInutXml'
        '</inutNFe>';

    final inutAssinado = _assinarElemento(inutXml, id);

    final url = _url(ETipoServicoSefaz.nfeInutilizacao);
    final envelope = SoapBuilder.inutilizacao(
      xmlInutAssinado: inutAssinado,
      cUF: cUF,
      tpAmb: _ambiente.xmlValue,
    );
    final resp = await _client.post(url, envelope);
    return RetornoInutilizacao.fromSoapXml(resp);
  }

  // ─── Consulta de Protocolo ────────────────────────────────────────────────

  /// Consulta a situação de uma NFC-e pelo número da chave de acesso.
  Future<RetornoAutorizacao> consultarProtocolo(String chNFe) async {
    final url = _url(ETipoServicoSefaz.nfeConsultaProtocolo);
    final envelope = SoapBuilder.consultaProtocolo(
      chNFe: chNFe,
      cUF: _estado.codigo,
      tpAmb: _ambiente.xmlValue,
    );
    final resp = await _client.post(url, envelope);
    // consSitNFe retorna retConsSitNFe com estrutura similar a retEnviNFe
    return RetornoAutorizacao.fromSoapXml(_normalizeConsSit(resp));
  }

  /// Fecha o cliente HTTP. Chame ao terminar todas as requisições.
  void close() => _client.close();

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _url(ETipoServicoSefaz servico) =>
      EnderecoSefaz.obter(estado: _estado, ambiente: _ambiente, servico: servico);

  bool _isAssinado(String xml) => xml.contains('<Signature');

  String _loteId() => DateTime.now().millisecondsSinceEpoch.toString().padLeft(15, '0').substring(0, 15);

  /// Assina um elemento XML standalone (como o `<evento>`).
  String _assinarElemento(String xmlEl, String id) {
    // Embrulha temporariamente para que o assinador encontre o Id
    final wrapped =
        '<root xmlns="http://www.portalfiscal.inf.br/nfe">$xmlEl</root>';
    final signed = _assinador.assinar(wrapped);
    // Retorna apenas o elemento original + Signature, sem o wrapper
    final doc = XmlDocument.parse(signed);
    final root = doc.rootElement;
    final elements = root.children.whereType<XmlElement>().toList();
    return elements.map((e) => e.toXmlString()).join();
  }

  /// Normaliza `retConsSitNFe` para o formato `retEnviNFe` para reutilizar o parser.
  String _normalizeConsSit(String xml) =>
      xml.replaceAll('retConsSitNFe', 'retEnviNFe')
         .replaceAll('protNFe', 'protNFe'); // noop — estrutura compatível
}
