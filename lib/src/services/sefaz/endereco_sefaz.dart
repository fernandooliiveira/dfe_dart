import '../../enum/estado.dart';
import '../../enum/tipo_ambiente.dart';
import 'tipo_servico_sefaz.dart';

/// Lookup de endpoints SOAP da SEFAZ por estado + ambiente + serviço.
///
/// Baseado na NT 2019.001 e nas documentações estaduais (NFC-e modelo 65).
class EnderecoSefaz {
  EnderecoSefaz._();

  // chave: '<codigo_uf>-<tpAmb>-<servico>'
  static final _tabela = <String, String>{
    // ── São Paulo (35) ──────────────────────────────────────────────────────
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.sp, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.sp, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',

    // ── Minas Gerais (31) ───────────────────────────────────────────────────
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfceAutorizacao4',
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NfceRetAutorizacao4',
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4',
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4',
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4',
    _k(EEstado.mg, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NfceAutorizacao4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NfceRetAutorizacao4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4',
    _k(EEstado.mg, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4',

    // ── Paraná (41) ─────────────────────────────────────────────────────────
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NfceAutorizacao4',
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NfceRetAutorizacao4',
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeStatusServico4',
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeConsultaProtocolo4',
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento4',
    _k(EEstado.pr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe2.fazenda.pr.gov.br/nfe/NFeInutilizacao4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe2.fazenda.pr.gov.br/nfe/NfceAutorizacao4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe2.fazenda.pr.gov.br/nfe/NfceRetAutorizacao4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe2.fazenda.pr.gov.br/nfe/NFeStatusServico4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe2.fazenda.pr.gov.br/nfe/NFeConsultaProtocolo4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe2.fazenda.pr.gov.br/nfe/NFeRecepcaoEvento4',
    _k(EEstado.pr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe2.fazenda.pr.gov.br/nfe/NFeInutilizacao4',

    // ── Rio Grande do Sul (43) ──────────────────────────────────────────────
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfceAutorizacao/NfceAutorizacao4.asmx',
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfceRetAutorizacao/NfceRetAutorizacao4.asmx',
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsultaProtocolo/NfeConsultaProtocolo4.asmx',
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRecepcaoEvento/NfeRecepcaoEvento4.asmx',
    _k(EEstado.rs, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeInutilizacao/NfeInutilizacao4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefazrs.rs.gov.br/ws/NfceAutorizacao/NfceAutorizacao4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefazrs.rs.gov.br/ws/NfceRetAutorizacao/NfceRetAutorizacao4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefazrs.rs.gov.br/ws/NfeConsultaProtocolo/NfeConsultaProtocolo4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefazrs.rs.gov.br/ws/NfeRecepcaoEvento/NfeRecepcaoEvento4.asmx',
    _k(EEstado.rs, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefazrs.rs.gov.br/ws/NfeInutilizacao/NfeInutilizacao4.asmx',

    // ── Rio de Janeiro (33) ─────────────────────────────────────────────────
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NfceAutorizacao4',
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NfceRetAutorizacao4',
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NFeStatusServico4',
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NFeConsultaProtocolo4',
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NFeRecepcaoEvento4',
    _k(EEstado.rj, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.rj.gov.br/nfe-ws/services/NFeInutilizacao4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NfceAutorizacao4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NfceRetAutorizacao4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NFeStatusServico4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NFeConsultaProtocolo4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NFeRecepcaoEvento4',
    _k(EEstado.rj, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.fazenda.rj.gov.br/nfe-ws/services/NFeInutilizacao4',

    // ── Santa Catarina (42) ─────────────────────────────────────────────────
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://hom.nfe.sef.sc.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://hom.nfe.sef.sc.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://hom.nfe.sef.sc.gov.br/ws/NFeStatusServico4',
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://hom.nfe.sef.sc.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://hom.nfe.sef.sc.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.sc, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://hom.nfe.sef.sc.gov.br/ws/NFeInutilizacao4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sef.sc.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sef.sc.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sef.sc.gov.br/ws/NFeStatusServico4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sef.sc.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sef.sc.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.sc, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sef.sc.gov.br/ws/NFeInutilizacao4',

    // ── Goiás (52) ──────────────────────────────────────────────────────────
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.go, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homolog.sefaz.go.gov.br/nfeweb/services/NFeInutilizacao4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.go, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.go.gov.br/nfeweb/services/NFeInutilizacao4',

    // ── Mato Grosso do Sul (50) ─────────────────────────────────────────────
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.ms.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.ms.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.ms.gov.br/ws/NFeStatusServico4',
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.ms.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.ms.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.ms, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.ms.gov.br/ws/NFeInutilizacao4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.ms.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.ms.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.ms.gov.br/ws/NFeStatusServico4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.ms.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.ms.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.ms, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.ms.gov.br/ws/NFeInutilizacao4',

    // ── Mato Grosso (51) ────────────────────────────────────────────────────
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfceAutorizacao4',
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfceRetAutorizacao4',
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NFeStatusServico4',
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NFeConsultaProtocolo4',
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NFeRecepcaoEvento4',
    _k(EEstado.mt, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sefaz.mt.gov.br/nfcews/services/NFeInutilizacao4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NfceAutorizacao4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NfceRetAutorizacao4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NFeStatusServico4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NFeConsultaProtocolo4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NFeRecepcaoEvento4',
    _k(EEstado.mt, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.mt.gov.br/nfcews/services/NFeInutilizacao4',

    // ── Distrito Federal (53) ───────────────────────────────────────────────
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sef.df.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sef.df.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sef.df.gov.br/ws/NFeStatusServico4',
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sef.df.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sef.df.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.df, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sef.df.gov.br/ws/NFeInutilizacao4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sef.df.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sef.df.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sef.df.gov.br/ws/NFeStatusServico4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sef.df.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sef.df.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.df, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sef.df.gov.br/ws/NFeInutilizacao4',

    // ── Espírito Santo (32) ─────────────────────────────────────────────────
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sefaz.es.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sefaz.es.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sefaz.es.gov.br/ws/NFeStatusServico4',
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sefaz.es.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sefaz.es.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.es, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sefaz.es.gov.br/ws/NFeInutilizacao4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.es.gov.br/ws/NfceAutorizacao4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.es.gov.br/ws/NfceRetAutorizacao4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.es.gov.br/ws/NFeStatusServico4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.es.gov.br/ws/NFeConsultaProtocolo4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.es.gov.br/ws/NFeRecepcaoEvento4',
    _k(EEstado.es, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.es.gov.br/ws/NFeInutilizacao4',

    // ── Bahia (29) ──────────────────────────────────────────────────────────
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://hnfe.sefaz.ba.gov.br/webservices/NfceAutorizacao4/NfceAutorizacao4.asmx',
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://hnfe.sefaz.ba.gov.br/webservices/NfceRetAutorizacao4/NfceRetAutorizacao4.asmx',
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://hnfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx',
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://hnfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://hnfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
    _k(EEstado.ba, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://hnfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.ba.gov.br/webservices/NfceAutorizacao4/NfceAutorizacao4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.ba.gov.br/webservices/NfceRetAutorizacao4/NfceRetAutorizacao4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
    _k(EEstado.ba, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx',

    // ── Pernambuco (26) ─────────────────────────────────────────────────────
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NfceAutorizacao4',
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NfceRetAutorizacao4',
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NFeStatusServico4',
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NFeConsultaProtocolo4',
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NFeRecepcaoEvento4',
    _k(EEstado.pe, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfcehomolog.sefaz.pe.gov.br/nfe-service/NFeInutilizacao4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NfceAutorizacao4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NfceRetAutorizacao4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NFeStatusServico4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NFeConsultaProtocolo4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NFeRecepcaoEvento4',
    _k(EEstado.pe, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfce.sefaz.pe.gov.br/nfe-service/NFeInutilizacao4',

    // ── Ceará (23) ──────────────────────────────────────────────────────────
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.ce, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfceh.sefaz.ce.gov.br/nfeservice/NFeInutilizacao4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.ce, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfce.sefaz.ce.gov.br/nfeservice/NFeInutilizacao4',

    // ── Amazonas (13) ───────────────────────────────────────────────────────
    // AM usa SVRS (Rio Grande do Sul) como autorizador para NFC-e
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.am, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.am.gov.br/services2/services/NfceAutorizacao4',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.am.gov.br/services2/services/NfceRetAutorizacao4',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.am.gov.br/services2/services/NFeStatusServico4',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.am.gov.br/services2/services/NFeConsultaProtocolo4',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.am.gov.br/services2/services/NFeRecepcaoEvento4',
    _k(EEstado.am, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.am.gov.br/services2/services/NFeInutilizacao4',

    // ── Pará (15) ────────────────────────────────────────────────────────────
    // PA usa SVRS como autorizador para NFC-e
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.pa, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://app.sefa.pa.gov.br/nfe/services/NfceAutorizacao4',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://app.sefa.pa.gov.br/nfe/services/NfceRetAutorizacao4',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://app.sefa.pa.gov.br/nfe/services/NFeStatusServico4',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://app.sefa.pa.gov.br/nfe/services/NFeConsultaProtocolo4',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://app.sefa.pa.gov.br/nfe/services/NFeRecepcaoEvento4',
    _k(EEstado.pa, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://app.sefa.pa.gov.br/nfe/services/NFeInutilizacao4',

    // ── Maranhão (21) ────────────────────────────────────────────────────────
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://hom.sefaz.ma.gov.br/nfe/services/NfceAutorizacao4',
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://hom.sefaz.ma.gov.br/nfe/services/NfceRetAutorizacao4',
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://hom.sefaz.ma.gov.br/nfe/services/NFeStatusServico4',
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://hom.sefaz.ma.gov.br/nfe/services/NFeConsultaProtocolo4',
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://hom.sefaz.ma.gov.br/nfe/services/NFeRecepcaoEvento4',
    _k(EEstado.ma, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://hom.sefaz.ma.gov.br/nfe/services/NFeInutilizacao4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://www.sefaz.ma.gov.br/nfe/services/NfceAutorizacao4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://www.sefaz.ma.gov.br/nfe/services/NfceRetAutorizacao4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://www.sefaz.ma.gov.br/nfe/services/NFeStatusServico4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://www.sefaz.ma.gov.br/nfe/services/NFeConsultaProtocolo4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://www.sefaz.ma.gov.br/nfe/services/NFeRecepcaoEvento4',
    _k(EEstado.ma, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://www.sefaz.ma.gov.br/nfe/services/NFeInutilizacao4',

    // ── Piauí (22) ───────────────────────────────────────────────────────────
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.pi, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sefaz.pi.gov.br/nfeservice/NFeInutilizacao4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.pi, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.pi.gov.br/nfeservice/NFeInutilizacao4',

    // ── Rio Grande do Norte (24) ─────────────────────────────────────────────
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.rn, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.set.rn.gov.br/nfeweb/services/NFeInutilizacao4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.set.rn.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.set.rn.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.set.rn.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.set.rn.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.set.rn.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.rn, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.set.rn.gov.br/nfeweb/services/NFeInutilizacao4',

    // ── Paraíba (25) ─────────────────────────────────────────────────────────
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.pb, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sefaz.pb.gov.br/nfeweb/services/NFeInutilizacao4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.pb, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.pb.gov.br/nfeweb/services/NFeInutilizacao4',

    // ── Alagoas (27) ─────────────────────────────────────────────────────────
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.al, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.sefaz.al.gov.br/nfeservice/NFeInutilizacao4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.al.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.al.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.al.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.al.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.al.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.al, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.al.gov.br/nfeservice/NFeInutilizacao4',

    // ── Sergipe (28) ─────────────────────────────────────────────────────────
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.se.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.se.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.se.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.se.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.se.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.se, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.se.gov.br/nfeservice/NFeInutilizacao4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.se.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.se.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.se.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.se.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.se.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.se, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.se.gov.br/nfeservice/NFeInutilizacao4',

    // ── Tocantins (17) — usa SVRS para NFC-e ────────────────────────────────
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.to, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.to, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.to.gov.br/nfeweb/services/NFeInutilizacao4',

    // ── Rondônia (11) — usa SVRS para NFC-e ─────────────────────────────────
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.ro, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NfceAutorizacao4',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NfceRetAutorizacao4',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NFeStatusServico4',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NFeConsultaProtocolo4',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NFeRecepcaoEvento4',
    _k(EEstado.ro, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefin.ro.gov.br/nfeweb/services/NFeInutilizacao4',

    // ── Acre (12), Roraima (14), Amapá (16) — usam SVRS para NFC-e ──────────
    // AC
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.ac, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.ac, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaznet.ac.gov.br/nfeservice/NFeInutilizacao4',
    // RR
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.rr, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.rr, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.rr.gov.br/nfeservice/NFeInutilizacao4',
    // AP
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceautorizacao4.asmx',
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfceretautorizacao4.asmx',
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeStatusServico):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
    _k(EEstado.ap, ETipoAmbiente.homologacao, ETipoServicoSefaz.nfeInutilizacao):
        'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfceAutorizacao):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NfceAutorizacao4',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfceRetAutorizacao):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NfceRetAutorizacao4',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfeStatusServico):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NFeStatusServico4',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfeConsultaProtocolo):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NFeConsultaProtocolo4',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfeRecepcaoEvento):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NFeRecepcaoEvento4',
    _k(EEstado.ap, ETipoAmbiente.producao, ETipoServicoSefaz.nfeInutilizacao):
        'https://nfe.sefaz.ap.gov.br/nfeservice/NFeInutilizacao4',
  };

  /// Retorna a URL do endpoint para o estado, ambiente e serviço especificados.
  ///
  /// Lança [ArgumentError] se o estado/ambiente/serviço não estiver cadastrado.
  /// Utilize [registrar] para adicionar estados não incluídos na tabela padrão.
  static String obter({
    required EEstado estado,
    required ETipoAmbiente ambiente,
    required ETipoServicoSefaz servico,
  }) {
    final url = _tabela[_k(estado, ambiente, servico)];
    if (url == null) {
      throw ArgumentError(
          'Endpoint não cadastrado: ${estado.name} / ${ambiente.name} / ${servico.label}. '
          'Use EnderecoSefaz.registrar() para adicionar.');
    }
    return url;
  }

  /// Registra (ou sobrescreve) um endpoint customizado.
  static void registrar({
    required EEstado estado,
    required ETipoAmbiente ambiente,
    required ETipoServicoSefaz servico,
    required String url,
  }) {
    _tabela[_k(estado, ambiente, servico)] = url;
  }

  static String _k(
          EEstado e, ETipoAmbiente a, ETipoServicoSefaz s) =>
      '${e.codigo}-${a.xmlValue}-${s.wsdlName}';
}
