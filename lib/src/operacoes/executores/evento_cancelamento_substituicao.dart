import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoCancelamentoSubstituicao(
  OperacaoContexto contexto,
) async {
  final protocolo = contexto.config.requireExtra(
    OperacaoConfiguracao.protocoloEvento,
    'protocolo de autorizacao para cancelamento por substituicao',
  );
  final justificativa = contexto.config.requireExtra(
    OperacaoConfiguracao.cancelamentoJustificativa,
    'justificativa do cancelamento por substituicao',
  );
  final chaveReferencia = contexto.config.requireExtra(
    OperacaoConfiguracao.chaveReferencia,
    'chave de referencia para substituicao',
  );

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110112',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Cancelamento por Substituicao',
    campos: [
      EventoCampo(tag: 'nProt', valor: protocolo),
      EventoCampo(tag: 'xJust', valor: justificativa),
      EventoCampo(tag: 'chNFeRef', valor: chaveReferencia),
    ],
  );

  await contexto.executarOperacao(
    'Evento de Cancelamento por Substituicao',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
