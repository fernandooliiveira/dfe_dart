import 'dart:convert';
import 'dart:io';

import 'package:xml_sign_dart/src/certificado.dart';
import 'package:xml_sign_dart/src/entidades/nfe.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/nfe_helper.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';
import 'package:xml_sign_dart/src/sefaz_endpoints.dart';
import 'package:xml_sign_dart/src/sefaz_service.dart';

typedef AcaoSoap = Future<SefazSoapResponse> Function();

class OperacaoContexto {
  OperacaoContexto._({
    required this.config,
    required this.certBundle,
    required this.ambiente,
    required this.uf,
    required this.tpAmb,
    required this.codigoUf,
    required this.cnpjEmitente,
    required this.idCSC,
    required this.csc,
    required this.helper,
    required this.sefazService,
    required this.nfceModelo65Assinada,
    required this.xmlNfceAssinada,
    required this.chaveNFe,
    required this.numeroDocumento,
    required this.dataReferencia,
  });

  final OperacaoConfiguracao config;
  final CertBundle certBundle;
  final Ambiente ambiente;
  final String uf;
  final String tpAmb;
  final String codigoUf;
  final String cnpjEmitente;
  final String idCSC;
  final String csc;
  final NFeHelper helper;
  final SefazService sefazService;
  final NFe nfceModelo65Assinada;
  final String xmlNfceAssinada;
  final String chaveNFe;
  final String numeroDocumento;
  final DateTime dataReferencia;

  TipoDocumento get tipoPadrao => TipoDocumento.nfce;
  String get anoFiscal => doisUltimosDigitosAno(dataReferencia);

  static Future<OperacaoContexto> carregar({
    required OperacaoConfiguracao configuracao,
    String numeroDocumento = '1',
    DateTime? dataReferencia,
  }) async {
    final arquivoCertificado = File(configuracao.certificadoPath);
    if (!await arquivoCertificado.exists()) {
      throw FileSystemException(
        'Arquivo de certificado nao encontrado',
        arquivoCertificado.path,
      );
    }

    final certBundle = await loadPfx(
      base64Encode(await arquivoCertificado.readAsBytes()),
      configuracao.certificadoSenha,
    );

    final helper = NFeHelper(certificado: certBundle);
    final sefazService = SefazService();
    final ambiente = configuracao.ambiente;
    final tpAmb = ambiente == Ambiente.producao ? '1' : '2';
    final codigoUf = codigoUfNumerico(configuracao.uf);
    final dataBase = dataReferencia ?? DateTime.now();

    final nfce = criarNFCeExemplo(
      numero: numeroDocumento,
      tpAmb: tpAmb,
      uf: configuracao.uf,
      ambiente: ambiente,
      idCSC: configuracao.idCsc,
      csc: configuracao.csc,
      sefazService: sefazService,
    );
    final nfceAssinada = helper.assinar(nfce);
    final xmlNfceAssinada = nfceAssinada.toXml().toXmlString();
    final chaveNFe = extrairChaveAcesso(nfceAssinada);

    return OperacaoContexto._(
      config: configuracao,
      certBundle: certBundle,
      ambiente: ambiente,
      uf: configuracao.uf,
      tpAmb: tpAmb,
      codigoUf: codigoUf,
      cnpjEmitente: configuracao.emitenteCnpj,
      idCSC: configuracao.idCsc,
      csc: configuracao.csc,
      helper: helper,
      sefazService: sefazService,
      nfceModelo65Assinada: nfceAssinada,
      xmlNfceAssinada: xmlNfceAssinada,
      chaveNFe: chaveNFe,
      numeroDocumento: numeroDocumento,
      dataReferencia: dataBase,
    );
  }

  Future<void> executarOperacao(String titulo, AcaoSoap acao) async {
    print('\n== $titulo ==');
    try {
      final resposta = await acao();
      if (resposta.isFault) {
        print('SOAP fault recebido:');
        print(resposta.fault?.toXmlString(pretty: true));
      } else if (resposta.payload != null) {
        print('Resposta:');
        print(resposta.payload!.toXmlString(pretty: true));
      } else {
        print('Resposta SOAP sem payload identificada.');
      }
    } catch (error) {
      print('Falha ao executar $titulo: $error');
    }
  }
}
