import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoInsucessoEntrega(OperacaoContexto contexto) async {
  final protocolo = contexto.config.requireExtra(
    OperacaoConfiguracao.protocoloEvento,
    'protocolo do evento de insucesso',
  );
  final justificativa = contexto.config.requireExtra(
    OperacaoConfiguracao.insucessoJustificativa,
    'justificativa do insucesso de entrega',
  );

  final tentativaEntrega =
      contexto.config.extra(OperacaoConfiguracao.eventoTentativaEntrega) ??
      formatarDataComOffset(DateTime.now());

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110190',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Insucesso na Entrega',
    campos: [
      EventoCampo(tag: 'nProt', valor: protocolo),
      EventoCampo(tag: 'dhTentativaEntrega', valor: tentativaEntrega),
      EventoCampo(tag: 'xJust', valor: justificativa),
    ],
  );

  await contexto.executarOperacao(
    'Evento Insucesso de Entrega',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
