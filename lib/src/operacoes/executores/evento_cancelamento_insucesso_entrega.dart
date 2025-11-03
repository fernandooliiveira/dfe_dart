import 'package:xml_sign_dart/src/entidades/env_evento.dart';
import 'package:xml_sign_dart/src/envia-nfe.dart';
import 'package:xml_sign_dart/src/operacoes/configuracao.dart';
import 'package:xml_sign_dart/src/operacoes/contexto.dart';
import 'package:xml_sign_dart/src/operacoes/util.dart';

Future<void> executarEventoCancelamentoInsucessoEntrega(
  OperacaoContexto contexto,
) async {
  final protocolo = contexto.config.requireExtra(
    OperacaoConfiguracao.protocoloEvento,
    'protocolo do evento de insucesso a ser cancelado',
  );
  final justificativa = contexto.config.requireExtra(
    OperacaoConfiguracao.cancelamentoJustificativa,
    'justificativa do cancelamento do insucesso',
  );

  final xmlEnvEventoAssinado = assinarEventoGenerico(
    cert: contexto.certBundle,
    tpEvento: '110191',
    cOrgao: contexto.codigoUf,
    tpAmb: contexto.tpAmb,
    cnpjOuCpf: contexto.cnpjEmitente,
    chaveNFe: contexto.chaveNFe,
    descEvento: 'Cancelamento de Insucesso na Entrega',
    campos: [
      EventoCampo(tag: 'nProt', valor: protocolo),
      EventoCampo(tag: 'xJust', valor: justificativa),
    ],
  );

  await contexto.executarOperacao(
    'Evento Cancelamento de Insucesso na Entrega',
    () => enviarEvento(
      xmlEnvEvento: xmlEnvEventoAssinado,
      uf: contexto.uf,
      ambiente: contexto.ambiente,
      tipo: contexto.tipoPadrao,
      certificado: contexto.certBundle,
    ),
  );
}
