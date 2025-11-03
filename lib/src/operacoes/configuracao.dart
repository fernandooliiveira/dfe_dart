import 'dart:io';

import 'package:xml_sign_dart/src/sefaz_endpoints.dart';

class OperacaoConfiguracao {
  OperacaoConfiguracao({
    required this.certificadoPath,
    required this.certificadoSenha,
    required this.ambiente,
    required this.uf,
    required this.emitenteCnpj,
    required this.idCsc,
    required this.csc,
    Map<String, String>? extras,
  }) : extras = Map.unmodifiable(extras ?? const {});

  final String certificadoPath;
  final String certificadoSenha;
  final Ambiente ambiente;
  final String uf;
  final String emitenteCnpj;
  final String idCsc;
  final String csc;
  final Map<String, String> extras;

  static const protocoloAutorizacao = 'NFE_PROTOCOLO_AUTORIZACAO';
  static const chaveReferencia = 'NFE_CHAVE_REFERENCIA';
  static const hashEntregaEconf = 'NFE_EVENTO_ECONF_HASH';
  static const destinatarioUf = 'NFE_DEST_UF';
  static const destinatarioCnpj = 'NFE_DEST_CNPJ';
  static const destinatarioCpf = 'NFE_DEST_CPF';
  static const destinatarioIe = 'NFE_DEST_IE';
  static const manifestacaoJustificativa =
      'NFE_EVENTO_MANIFESTACAO_JUSTIFICATIVA';
  static const cancelamentoJustificativa =
      'NFE_EVENTO_CANCELAMENTO_JUSTIFICATIVA';
  static const insucessoJustificativa = 'NFE_EVENTO_INSUCESSO_JUSTIFICATIVA';
  static const interessadoCnpj = 'NFE_EVENTO_INTERESSADO_CNPJ';
  static const interessadoEmail = 'NFE_EVENTO_INTERESSADO_EMAIL';
  static const interessadoFone = 'NFE_EVENTO_INTERESSADO_FONE';
  static const reciboNumero = 'NFE_RECIBO_NUMERO';
  static const protocoloEvento = 'NFE_EVENTO_PROTOCOLO';
  static const inutilizacaoSerie = 'NFE_INUT_SERIE';
  static const inutilizacaoNumeroInicial = 'NFE_INUT_NUM_INI';
  static const inutilizacaoNumeroFinal = 'NFE_INUT_NUM_FIM';
  static const inutilizacaoJustificativa = 'NFE_INUT_JUSTIFICATIVA';
  static const distribuicaoUltNsu = 'NFE_DFE_ULT_NSU';
  static const cartaCorrecaoTexto = 'NFE_EVENTO_CCE_TEXTO';
  static const cartaCorrecaoCondUso = 'NFE_EVENTO_CCE_COND_USO';
  static const eventoVersaoAplicativo = 'NFE_EVENTO_VERSAO_APLIC';
  static const eventoTentativaEntrega = 'NFE_EVENTO_TENTATIVA_ENTREGA';
  static const numeroDocumento = 'NFE_NUMERO_DOC';

  String requireExtra(String chave, String descricao) {
    final valor = extras[chave];
    if (valor == null || valor.trim().isEmpty) {
      throw StateError(
        'Parametro obrigatorio $descricao ausente. Defina a variavel $chave.',
      );
    }
    return valor.trim();
  }

  String? extra(String chave) => extras[chave]?.trim();

  static OperacaoConfiguracao fromEnvironment({Map<String, String>? env}) {
    final source = env ?? Platform.environment;

    String _require(String key, String descricao) {
      final value = source[key];
      if (value == null || value.trim().isEmpty) {
        throw StateError(
          'Variavel de ambiente obrigatoria $descricao ($key) nao informada.',
        );
      }
      return value.trim();
    }

    Ambiente _parseAmbiente(String valor) {
      final normalizado = valor.trim().toLowerCase();
      switch (normalizado) {
        case 'producao':
        case '1':
        case 'prod':
          return Ambiente.producao;
        case 'homologacao':
        case '2':
        case 'hml':
        default:
          return Ambiente.homologacao;
      }
    }

    final extras = <String, String>{};
    for (final entry in source.entries) {
      if (entry.key.startsWith('NFE_') && entry.value.trim().isNotEmpty) {
        extras[entry.key] = entry.value.trim();
      }
    }

    return OperacaoConfiguracao(
      certificadoPath: _require(
        'CERT_PATH',
        'caminho do certificado (CERT_PATH)',
      ),
      certificadoSenha: _require(
        'CERT_PASSWORD',
        'senha do certificado (CERT_PASSWORD)',
      ),
      ambiente: _parseAmbiente(
        _require('NFE_AMBIENTE', 'ambiente da SEFAZ (NFE_AMBIENTE)'),
      ),
      uf: _require('NFE_UF', 'UF do emissor (NFE_UF)'),
      emitenteCnpj: _require(
        'NFE_EMIT_CNPJ',
        'CNPJ do emitente (NFE_EMIT_CNPJ)',
      ),
      idCsc: _require('NFE_CSC_ID', 'ID do CSC (NFE_CSC_ID)'),
      csc: _require('NFE_CSC_TOKEN', 'token do CSC (NFE_CSC_TOKEN)'),
      extras: extras,
    );
  }
}
