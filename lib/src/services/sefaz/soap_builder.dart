import 'tipo_servico_sefaz.dart';

const _soap12 = 'http://www.w3.org/2003/05/soap-envelope';
const _nfe = 'http://www.portalfiscal.inf.br/nfe';

/// Constrói envelopes SOAP 1.2 para os serviços da SEFAZ (NFC-e 4.00).
class SoapBuilder {
  SoapBuilder._();

  // ─── Status do Serviço ────────────────────────────────────────────────────

  static String statusServico({
    required String cUF,
    required String tpAmb,
  }) {
    final ns = ETipoServicoSefaz.nfeStatusServico.namespace;
    return _envelope(ns, cUF, '''
      <consStatServ versao="4.00" xmlns="$_nfe">
        <tpAmb>$tpAmb</tpAmb>
        <xServ>STATUS</xServ>
        <cUF>$cUF</cUF>
      </consStatServ>''');
  }

  // ─── Autorização NFC-e ────────────────────────────────────────────────────

  /// [xmlNfeAssinado] deve ser o XML completo da NFC-e já assinada (elemento `<NFe>`).
  /// [idLote] identificador do lote (sugerido: sequencial numérico de 15 dígitos).
  static String autorizacao({
    required String xmlNfeAssinado,
    required String cUF,
    required String tpAmb,
    String idLote = '000000000000001',
  }) {
    final ns = ETipoServicoSefaz.nfceAutorizacao.namespace;
    return _envelope(ns, cUF, '''
      <enviNFe versao="4.00" xmlns="$_nfe">
        <idLote>$idLote</idLote>
        <indSinc>1</indSinc>
        $xmlNfeAssinado
      </enviNFe>''');
  }

  // ─── Consulta Protocolo ───────────────────────────────────────────────────

  static String consultaProtocolo({
    required String chNFe,
    required String cUF,
    required String tpAmb,
  }) {
    final ns = ETipoServicoSefaz.nfeConsultaProtocolo.namespace;
    return _envelope(ns, cUF, '''
      <consSitNFe versao="4.00" xmlns="$_nfe">
        <tpAmb>$tpAmb</tpAmb>
        <xServ>CONSULTAR</xServ>
        <chNFe>$chNFe</chNFe>
      </consSitNFe>''');
  }

  // ─── Cancelamento ─────────────────────────────────────────────────────────

  /// [xmlEventoAssinado] deve ser o `<envEvento>` completo com a assinatura embutida.
  static String recepcaoEvento({
    required String xmlEventoAssinado,
    required String cUF,
    required String tpAmb,
  }) {
    final ns = ETipoServicoSefaz.nfeRecepcaoEvento.namespace;
    return _envelope(ns, cUF, xmlEventoAssinado);
  }

  // ─── Inutilização ─────────────────────────────────────────────────────────

  /// [xmlInutAssinado] deve ser o `<inutNFe>` completo com a assinatura embutida.
  static String inutilizacao({
    required String xmlInutAssinado,
    required String cUF,
    required String tpAmb,
  }) {
    final ns = ETipoServicoSefaz.nfeInutilizacao.namespace;
    return _envelope(ns, cUF, xmlInutAssinado);
  }

  // ─── Envelope genérico ────────────────────────────────────────────────────

  static String _envelope(String serviceNs, String cUF, String bodyContent) =>
      '<?xml version="1.0" encoding="UTF-8"?>'
      '<soap12:Envelope'
      ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'
      ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"'
      ' xmlns:soap12="$_soap12">'
      '<soap12:Header>'
      '<nfeCabecMsg xmlns="$serviceNs">'
      '<cUF>$cUF</cUF>'
      '<versaoDados>4.00</versaoDados>'
      '</nfeCabecMsg>'
      '</soap12:Header>'
      '<soap12:Body>'
      '<nfeDadosMsg xmlns="$serviceNs">'
      '$bodyContent'
      '</nfeDadosMsg>'
      '</soap12:Body>'
      '</soap12:Envelope>';
}
