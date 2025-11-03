import 'package:xml_sign_dart/src/assinar.dart';
import 'package:xml_sign_dart/src/certificado.dart';
import 'package:xml_sign_dart/src/entidades/det.dart';
import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/entidades/emit.dart';
import 'package:xml_sign_dart/src/entidades/inf_adic.dart';
import 'package:xml_sign_dart/src/entidades/nfe.dart';
import 'package:xml_sign_dart/src/entidades/pag.dart';
import 'package:xml_sign_dart/src/entidades/total.dart';
import 'package:xml_sign_dart/src/entidades/transp.dart';
import 'package:xml_sign_dart/src/qr_code.dart';
import 'package:xml_sign_dart/src/sefaz_endpoints.dart';
import 'package:xml_sign_dart/src/sefaz_service.dart';

const _mapaCodigoUf = {
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

String codigoUfNumerico(String uf) {
  final codigo = _mapaCodigoUf[uf.toUpperCase()];
  if (codigo == null) {
    throw ArgumentError('UF desconhecida: $uf');
  }
  return codigo;
}

String doisUltimosDigitosAno(DateTime data) =>
    data.year.toString().substring(2);

String montarIdInutilizacao({
  required String cUf,
  required String ano,
  required String cnpj,
  required String modelo,
  required String serie,
  required String numeroInicial,
  required String numeroFinal,
}) {
  final seriePadded = serie.padLeft(3, '0');
  final numeroInicialPadded = numeroInicial.padLeft(9, '0');
  final numeroFinalPadded = numeroFinal.padLeft(9, '0');
  return 'ID$cUf$ano$cnpj$modelo$seriePadded$numeroInicialPadded$numeroFinalPadded';
}

String montarIdEvento({
  required String tpEvento,
  required String chave,
  required String sequencia,
}) {
  final sequenciaPadded = sequencia.padLeft(2, '0');
  return 'ID$tpEvento$chave$sequenciaPadded';
}

String formatarDataComOffset(DateTime data) {
  final ano = data.year.toString().padLeft(4, '0');
  final mes = _duasCasas(data.month);
  final dia = _duasCasas(data.day);
  final hora = _duasCasas(data.hour);
  final minuto = _duasCasas(data.minute);
  final segundo = _duasCasas(data.second);

  final offset = data.timeZoneOffset;
  final sinal = offset.isNegative ? '-' : '+';
  final horasOffset = _duasCasas(offset.inHours.abs());
  final minutosOffset = _duasCasas(offset.inMinutes.abs() % 60);

  return '$ano-$mes-${dia}T$hora:$minuto:$segundo$sinal$horasOffset:$minutosOffset';
}

String extrairChaveAcesso(NFe nfe) {
  return nfe.infNFe.id.startsWith('NFe')
      ? nfe.infNFe.id.substring(3)
      : nfe.infNFe.id;
}

NFe criarNFCeExemplo({
  String numero = '1',
  required String tpAmb,
  required String uf,
  required Ambiente ambiente,
  required String idCSC,
  required String csc,
  required SefazService sefazService,
}) {
  final nfe = criarDocumentoExemplo(
    modelo: '65',
    numero: numero,
    tpImp: '4', // DANFE NFC-e (mensagem eletronica)
    indPres: '1', // Operacao presencial
    tpAmb: tpAmb,
  );

  final endpoints = sefazService.getEndpoints(
    uf: uf,
    tipo: TipoDocumento.nfce,
    ambiente: ambiente,
  );

  final urlBaseQRCode = endpoints[SefazServico.urlQrCode];
  final urlConsulta = endpoints[SefazServico.urlConsultaNfce];

  if (urlBaseQRCode == null || urlConsulta == null) {
    throw StateError('URLs de QRCode nao encontradas para $uf');
  }

  final chaveNumerica = extrairChaveAcesso(nfe);

  final qrCode = gerarQRCodeNFCe(
    urlBase: urlBaseQRCode,
    chaveNFe: chaveNumerica,
    versao: '100',
    tpAmb: nfe.infNFe.ide.tpAmb,
    idCSC: idCSC,
    csc: csc,
  );

  return NFe(
    infNFe: nfe.infNFe,
    infNFeSupl: InfNFeSupl(qrCode: qrCode, urlChave: urlConsulta),
  );
}

NFe criarDocumentoExemplo({
  required String modelo,
  required String numero,
  required String tpImp,
  required String indPres,
  required String tpAmb,
}) {
  const serie = '21';
  const tpEmis = '1';
  const cNF = '12345678';

  final chave = gerarChaveAcesso(
    modelo: modelo,
    numero: numero,
    serie: serie,
    tpEmis: tpEmis,
    cNF: cNF,
  );
  final cDV = chave.substring(chave.length - 1);
  final dhEmi = DateTime.now().toIso8601String();

  return NFe(
    infNFe: InfNFe(
      id: chave,
      versao: '4.00',
      ide: Ide(
        cUF: '52',
        cNF: cNF,
        natOp: 'VENDA',
        mod: modelo,
        serie: serie,
        nNF: numero,
        dhEmi: dhEmi,
        tpNF: '1',
        idDest: '1',
        cMunFG: '5208707',
        tpImp: tpImp,
        tpEmis: tpEmis,
        cDV: cDV,
        tpAmb: tpAmb,
        finNFe: '1',
        indFinal: '1',
        indPres: indPres,
        procEmi: '0',
        verProc: '1.0.0',
      ),
      emit: Emit(
        cnpj: '12345678000195',
        xNome: 'EMPRESA EXEMPLO LTDA',
        xFant: 'EXEMPLO',
        enderEmit: EnderEmit(
          xLgr: 'RUA EXEMPLO',
          nro: '123',
          xBairro: 'CENTRO',
          cMun: '5208707',
          xMun: 'GOIANIA',
          uf: 'GO',
          cep: '74000000',
          cPais: '1058',
          xPais: 'BRASIL',
        ),
        ie: '123456789',
        crt: '1',
      ),
      det: [
        Det(
          nItem: '1',
          prod: Prod(
            cProd: '001',
            cEAN: 'SEM GTIN',
            xProd: 'PRODUTO EXEMPLO $numero',
            ncm: '12345678',
            cfop: '5102',
            uCom: 'UN',
            qCom: '1.0000',
            vUnCom: '10.00',
            vProd: '10.00',
            cEANTrib: 'SEM GTIN',
            uTrib: 'UN',
            qTrib: '1.0000',
            vUnTrib: '10.00',
            indTot: '1',
          ),
          imposto: Imposto(
            icms: Icms(orig: '0', cst: '102'),
            pis: Pis(cst: '99'),
            cofins: Cofins(cst: '99'),
          ),
        ),
      ],
      total: Total(
        icmsTot: IcmsTot(
          vBC: '0.00',
          vICMS: '0.00',
          vICMSDeson: '0.00',
          vFCP: '0.00',
          vBCST: '0.00',
          vST: '0.00',
          vFCPST: '0.00',
          vFCPSTRet: '0.00',
          vProd: '10.00',
          vFrete: '0.00',
          vSeg: '0.00',
          vDesc: '0.00',
          vII: '0.00',
          vIPI: '0.00',
          vIPIDevol: '0.00',
          vPIS: '0.00',
          vCOFINS: '0.00',
          vOutro: '0.00',
          vNF: '10.00',
        ),
      ),
      transp: Transp(modFrete: '9'),
      pag: Pag(
        detPag: [DetPag(indPag: '0', tPag: '01', vPag: '10.00')],
      ),
      infRespTec: InfRespTec(
        cnpj: '04516513212651',
        xContato: 'Mauro Douglas',
        email: 'mauro.douglas@zetti.tech',
        fone: '6298165484659',
      ),
    ),
  );
}

String gerarChaveAcesso({
  required String modelo,
  required String numero,
  required String serie,
  required String tpEmis,
  required String cNF,
}) {
  const cUF = '52';
  const cnpj = '12345678000195';

  final agora = DateTime.now();
  final ano = agora.year.toString().substring(2);
  final mes = agora.month.toString().padLeft(2, '0');
  final seriePadded = serie.padLeft(3, '0');
  final numeroPadded = numero.padLeft(9, '0');

  final chaveSemDv =
      '$cUF$ano$mes$cnpj$modelo$seriePadded$numeroPadded$tpEmis$cNF';
  final dv = calcularDigitoVerificador(chaveSemDv);

  return 'NFe$chaveSemDv$dv';
}

String calcularDigitoVerificador(String chaveSemDv) {
  const pesos = [2, 3, 4, 5, 6, 7, 8, 9];
  var soma = 0;

  for (var i = chaveSemDv.length - 1, j = 0; i >= 0; i--, j++) {
    final digito = int.parse(chaveSemDv[i]);
    final peso = pesos[j % pesos.length];
    soma += digito * peso;
  }

  final modulo = soma % 11;
  final dv = 11 - modulo;

  if (dv == 0 || dv == 1) {
    return '0';
  }

  return dv.toString();
}

String montarEventoXml({
  required String tpEvento,
  required String cOrgao,
  required String tpAmb,
  required String cnpjOuCpf,
  required String chaveNFe,
  required String descEvento,
  List<EventoCampo> campos = const [],
  String sequencia = '1',
  String verEvento = '1.00',
  DateTime? dataEvento,
}) {
  final documento = cnpjOuCpf.replaceAll(RegExp(r'[^0-9]'), '');
  if (documento.isEmpty) {
    throw StateError('Documento do emitente para evento nao pode ser vazio.');
  }
  if (documento.length != 11 && documento.length != 14) {
    throw StateError(
      'Documento informado para evento deve possuir 11 (CPF) ou 14 (CNPJ) digitos.',
    );
  }

  final dhEvento = formatarDataComOffset(dataEvento ?? DateTime.now());

  final xml = EnvEvento(
    idLote: DateTime.now().millisecondsSinceEpoch.toString(),
    eventos: [
      Evento(
        infEvento: InfEvento(
          id: montarIdEvento(
            tpEvento: tpEvento,
            chave: chaveNFe,
            sequencia: sequencia,
          ),
          cOrgao: cOrgao,
          tpAmb: tpAmb,
          cnpj: documento.length == 14 ? documento : null,
          cpf: documento.length == 11 ? documento : null,
          chNFe: chaveNFe,
          dhEvento: dhEvento,
          tpEvento: tpEvento,
          nSeqEvento: sequencia,
          verEvento: verEvento,
          detEvento: DetEvento(descEvento: descEvento, campos: campos),
        ),
      ),
    ],
  ).toXmlString();

  return xml;
}

String assinarEventoGenerico({
  required CertBundle cert,
  required String tpEvento,
  required String cOrgao,
  required String tpAmb,
  required String cnpjOuCpf,
  required String chaveNFe,
  required String descEvento,
  List<EventoCampo> campos = const [],
  String sequencia = '1',
  String verEvento = '1.00',
  DateTime? dataEvento,
}) {
  final xmlOriginal = montarEventoXml(
    tpEvento: tpEvento,
    cOrgao: cOrgao,
    tpAmb: tpAmb,
    cnpjOuCpf: cnpjOuCpf,
    chaveNFe: chaveNFe,
    descEvento: descEvento,
    campos: campos,
    sequencia: sequencia,
    verEvento: verEvento,
    dataEvento: dataEvento,
  );

  return assinarXml(
    xmlOriginal: xmlOriginal,
    cert: cert,
    tipo: TipoAssinatura.evento,
  );
}

String _duasCasas(int valor) => valor.toString().padLeft(2, '0');
