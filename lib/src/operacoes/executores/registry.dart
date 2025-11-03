import 'package:xml_sign_dart/src/operacoes/contexto.dart';

import 'administrar_csc.dart' as administrar_csc;
import 'consulta_cadastro.dart' as consulta_cadastro;
import 'consulta_protocolo.dart' as consulta_protocolo;
import 'consulta_recibo.dart' as consulta_recibo;
import 'consulta_status_servico.dart' as status_servico;
import 'distribuicao_dfe.dart' as distribuicao_dfe;
import 'envio_nfce.dart' as envio_nfce;
import 'evento_ator_interessado.dart' as evento_ator_interessado;
import 'evento_cancelamento.dart' as evento_cancelamento;
import 'evento_cancelamento_econf.dart' as evento_cancelamento_econf;
import 'evento_cancelamento_insucesso_entrega.dart'
    as evento_cancelamento_insucesso;
import 'evento_cancelamento_substituicao.dart'
    as evento_cancelamento_substituicao;
import 'evento_carta_correcao.dart' as evento_carta_correcao;
import 'evento_econf.dart' as evento_econf;
import 'evento_epec.dart' as evento_epec;
import 'evento_insucesso_entrega.dart' as evento_insucesso_entrega;
import 'evento_manifestacao.dart' as evento_manifestacao;
import 'inutilizacao.dart' as inutilizacao;

typedef ExecutorOperacao = Future<void> Function(OperacaoContexto contexto);

Map<String, ExecutorOperacao> registrarOperacoes() => {
  'status-servico': status_servico.executarConsultaStatusServico,
  'envio-nfce': envio_nfce.executarEnvioNfce,
  'consulta-recibo': consulta_recibo.executarConsultaRecibo,
  'consulta-protocolo': consulta_protocolo.executarConsultaProtocolo,
  'evento-carta-correcao': evento_carta_correcao.executarEventoCartaCorrecao,
  'evento-cancelamento': evento_cancelamento.executarEventoCancelamento,
  'evento-cancelamento-substituicao':
      evento_cancelamento_substituicao.executarEventoCancelamentoSubstituicao,
  'evento-epec': evento_epec.executarEventoEpec,
  'evento-manifestacao': evento_manifestacao.executarEventoManifestacao,
  'evento-ator-interessado':
      evento_ator_interessado.executarEventoAtorInteressado,
  'evento-insucesso-entrega':
      evento_insucesso_entrega.executarEventoInsucessoEntrega,
  'evento-cancelamento-insucesso-entrega':
      evento_cancelamento_insucesso.executarEventoCancelamentoInsucessoEntrega,
  'evento-econf': evento_econf.executarEventoEconf,
  'evento-cancelamento-econf':
      evento_cancelamento_econf.executarEventoCancelamentoEconf,
  'inutilizacao': inutilizacao.executarInutilizacao,
  'consulta-cadastro': consulta_cadastro.executarConsultaCadastro,
  'distribuicao-dfe': distribuicao_dfe.executarDistribuicaoDfe,
  'administrar-csc': administrar_csc.executarAdministrarCsc,
};
