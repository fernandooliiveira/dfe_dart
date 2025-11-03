import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';
import 'package:xml_sign_dart/src/certificado.dart';
import 'package:xml_sign_dart/src/sefaz_endpoints.dart';

const Map<String, String> _codigoUf = {
  'AC': '12',
  'AL': '27',
  'AM': '13',
  'AP': '16',
  'BA': '29',
  'CE': '23',
  'DF': '53',
  'ES': '32',
  'GO': '52',
  'MA': '21',
  'MG': '31',
  'MS': '50',
  'MT': '51',
  'PA': '15',
  'PB': '25',
  'PE': '26',
  'PI': '22',
  'PR': '41',
  'RJ': '33',
  'RN': '24',
  'RO': '11',
  'RR': '14',
  'RS': '43',
  'SC': '42',
  'SE': '28',
  'SP': '35',
  'TO': '17',
};

class _ServicoSoapConfig {
  const _ServicoSoapConfig({
    required this.namespace,
    required this.versaoDados,
    required this.incluirCodigoUf,
  });

  final String namespace;
  final String versaoDados;
  final bool incluirCodigoUf;

  String get cabecalhoTag => 'nfeCabecMsg';
  String get dadosMsgTag => 'nfeDadosMsg';
}

class SefazSoapResponse {
  const SefazSoapResponse({
    required this.document,
    required this.envelope,
    required this.body,
    this.payload,
    this.fault,
  });

  final XmlDocument document;
  final XmlElement envelope;
  final XmlElement body;
  final XmlElement? payload;
  final XmlElement? fault;

  bool get isFault => fault != null;
}

const Map<SefazServico, _ServicoSoapConfig> _soapConfigs = {
  SefazServico.nfeAutorizacao400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NFeAutorizacao4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeRetAutorizacao400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NFeRetAutorizacao4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeInutilizacao400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeInutilizacao4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeConsultaProtocolo400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeConsultaProtocolo4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeStatusServico400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NfeStatusServico4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.recepcaoEvento400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/RecepcaoEvento4',
    versaoDados: '1.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeConsultaCadastro400: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/CadConsultaCadastro4',
    versaoDados: '4.00',
    incluirCodigoUf: true,
  ),
  SefazServico.nfeDistribuicaoDFe101: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/NFeDistribuicaoDFe',
    versaoDados: '1.01',
    incluirCodigoUf: true,
  ),
  SefazServico.administrarCscNfce100: _ServicoSoapConfig(
    namespace: 'http://www.portalfiscal.inf.br/nfe/wsdl/AdministrarCSCNFCe',
    versaoDados: '1.00',
    incluirCodigoUf: true,
  ),
};

XmlElement? _findChildByLocalName(XmlElement parent, String localName) {
  for (final child in parent.children.whereType<XmlElement>()) {
    if (child.name.local == localName) {
      return child;
    }
  }
  return null;
}

Future<SefazSoapResponse> _enviarParaSefaz({
  required String payload,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  required SefazServico servico,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) async {
  final config = _soapConfigs[servico];
  if (config == null) {
    throw ArgumentError.value(servico, 'servico', 'Serviço não suportado');
  }

  final codigoUf = _codigoUf[uf.toUpperCase()];
  if (config.incluirCodigoUf && codigoUf == null) {
    throw ArgumentError.value(uf, 'uf', 'UF inválida para envio ao SEFAZ');
  }

  final url = SefazEndpoints.getUrl(
    tipo: tipo,
    uf: uf,
    ambiente: ambiente,
    servico: servico,
  );

  if (url == null) {
    throw Exception('Serviço ${servico.codigo} não disponível para $uf');
  }

  final soapEnvelope =
      '''<?xml version="1.0" encoding="UTF-8"?>
<soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Header>
    <${config.cabecalhoTag} xmlns="${config.namespace}">
${config.incluirCodigoUf ? '      <cUF>$codigoUf</cUF>\n' : ''}      <versaoDados>${versaoDados ?? config.versaoDados}</versaoDados>
    </${config.cabecalhoTag}>
  </soap12:Header>
  <soap12:Body>
    <${config.dadosMsgTag} xmlns="${config.namespace}">
      $payload
    </${config.dadosMsgTag}>
  </soap12:Body>
</soap12:Envelope>''';

  final context = certificado.toSecurityContext();
  final client = HttpClient(context: context)..connectionTimeout = timeout;
  final uri = Uri.parse(url);

  try {
    final request = await client.postUrl(uri);
    request.headers.removeAll(HttpHeaders.contentTypeHeader);
    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/soap+xml; charset=utf-8',
    );
    request.write(soapEnvelope);

    final response = await request.close();
    final responseBody = await utf8.decodeStream(response);

    if (response.statusCode != HttpStatus.ok) {
      print(responseBody);
      throw HttpException('Erro HTTP: ${response.statusCode}', uri: uri);
    }

    final document = XmlDocument.parse(responseBody);
    final envelope = document.rootElement;
    final body = _findChildByLocalName(envelope, 'Body');

    if (body == null) {
      throw FormatException('Corpo SOAP ausente na resposta', responseBody);
    }

    final fault = _findChildByLocalName(body, 'Fault');
    XmlElement? payloadElement;
    for (final element in body.children.whereType<XmlElement>()) {
      if (!identical(element, fault)) {
        payloadElement = element;
        break;
      }
    }

    return SefazSoapResponse(
      document: document,
      envelope: envelope,
      body: body,
      payload: payloadElement,
      fault: fault,
    );
  } finally {
    client.close(force: true);
  }
}

Future<SefazSoapResponse> enviarNFe({
  required String xmlAssinado,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final nfeXml = _extrairCorpoNFe(xmlAssinado);
  final idLote = DateTime.now().millisecondsSinceEpoch.toString();

  final enviNFe =
      '''
<enviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="4.00">
  <idLote>$idLote</idLote>
  <indSinc>1</indSinc>
  $nfeXml
</enviNFe>''';

  return _enviarParaSefaz(
    payload: enviNFe,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.nfeAutorizacao400,
    timeout: timeout,
  );
}

/// Consulta o retorno da autorização (recibo) junto ao SEFAZ.
Future<SefazSoapResponse> enviarConsultaRecibo({
  required String xmlConsReciNFe,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlConsReciNFe,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.nfeRetAutorizacao400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Envia um pedido de inutilização de numeração.
Future<SefazSoapResponse> enviarInutilizacao({
  required String xmlInutNFe,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlInutNFe,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.nfeInutilizacao400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Consulta a situação (protocolo) de uma NFe/NFCe.
Future<SefazSoapResponse> enviarConsultaProtocolo({
  required String xmlConsSitNFe,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlConsSitNFe,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.nfeConsultaProtocolo400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Consulta o status de serviço para o ambiente informado.
Future<SefazSoapResponse> enviarConsultaStatusServico({
  required String xmlConsStatServ,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlConsStatServ,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.nfeStatusServico400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Envia um evento (carta de correção, cancelamento, manifesto, etc.).
Future<SefazSoapResponse> enviarEvento({
  required String xmlEnvEvento,
  required String uf,
  required Ambiente ambiente,
  required TipoDocumento tipo,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlEnvEvento,
    uf: uf,
    ambiente: ambiente,
    tipo: tipo,
    certificado: certificado,
    servico: SefazServico.recepcaoEvento400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Consulta cadastro de contribuintes (NFe).
Future<SefazSoapResponse> enviarConsultaCadastro({
  required String xmlConsCad,
  required String uf,
  required Ambiente ambiente,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlConsCad,
    uf: uf,
    ambiente: ambiente,
    tipo: TipoDocumento.nfe,
    certificado: certificado,
    servico: SefazServico.nfeConsultaCadastro400,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Distribui documentos fiscais eletrônicos (DF-e).
Future<SefazSoapResponse> enviarDistribuicaoDFe({
  required String xmlDistDFeInt,
  required String uf,
  required Ambiente ambiente,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlDistDFeInt,
    uf: uf,
    ambiente: ambiente,
    tipo: TipoDocumento.nfe,
    certificado: certificado,
    servico: SefazServico.nfeDistribuicaoDFe101,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

/// Gerencia CSC (Código de Segurança do Contribuinte) da NFC-e.
Future<SefazSoapResponse> enviarAdministrarCscNFCe({
  required String xmlAdmCsc,
  required String uf,
  required Ambiente ambiente,
  required CertBundle certificado,
  Duration timeout = const Duration(seconds: 30),
  String? versaoDados,
}) {
  return _enviarParaSefaz(
    payload: xmlAdmCsc,
    uf: uf,
    ambiente: ambiente,
    tipo: TipoDocumento.nfce,
    certificado: certificado,
    servico: SefazServico.administrarCscNfce100,
    timeout: timeout,
    versaoDados: versaoDados,
  );
}

String _extrairCorpoNFe(String xmlAssinado) {
  final doc = XmlDocument.parse(xmlAssinado);
  return doc.rootElement.toXmlString();
}
