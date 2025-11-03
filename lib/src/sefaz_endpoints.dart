// ignore_for_file: constant_identifier_names, non_constant_identifier_names, prefer_final_fields

/// Generated: Sefaz Endpoints (NFe + NFCe) with aliases and overrides.
///
/// Usage:
/// ```dart
/// final url = SefazEndpoints.getUrl(
///   tipo: TipoDocumento.nfce,
///   uf: 'GO',
///   ambiente: Ambiente.homologacao,
///   servico: SefazServico.nfeAutorizacao400,
/// );
/// ```
///
/// Notes:
/// - If a UF has no explicit endpoints, we fallback to the proper virtual system (SVRS/SVAN/SVC-*)
/// - Overrides for specific services are merged on top of the fallback cluster.
/// - NFC-e QRCode/Consulta URLs are included when available.

enum Ambiente { producao, homologacao }

enum TipoDocumento { nfe, nfce }

enum SefazServico {
  nfeAutorizacao400('NFeAutorizacao_4.00'),
  nfeRetAutorizacao400('NFeRetAutorizacao_4.00'),
  nfeInutilizacao400('NfeInutilizacao_4.00'),
  nfeConsultaProtocolo400('NfeConsultaProtocolo_4.00'),
  nfeStatusServico400('NfeStatusServico_4.00'),
  nfeConsultaCadastro400('NfeConsultaCadastro_4.00'),
  nfeDistribuicaoDFe101('NFeDistribuicaoDFe_1.01'),
  recepcaoEvento400('RecepcaoEvento_4.00'),
  administrarCscNfce100('AdministrarCSCNFCe_1.00'),
  urlConsultaNfce('URL-ConsultaNFCe'),
  urlQrCode('URL-QRCode');

  const SefazServico(this.codigo);
  final String codigo;
}

/// Tipos de clusters virtuais disponíveis para NFe
enum _ClusterNFe { svrs, svan, svcAN, svcRS, an }

/// Tipos de clusters virtuais disponíveis para NFCe
enum _ClusterNFCe { svrs }

class SefazEndpoints {
  SefazEndpoints._(); // Private constructor para prevenir instanciação

  // -------------------------------
  // Clusters (Virtual SEFAZ) - NFe
  // -------------------------------

  static const Map<_ClusterNFe, Map<Ambiente, Map<SefazServico, String>>>
  _nfeClusterEndpoints = {
    _ClusterNFe.svrs: {
      Ambiente.producao: {
        SefazServico.nfeAutorizacao400:
            'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://cad-homologacao.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx',
      },
    },
    _ClusterNFe.svan: {
      Ambiente.producao: {
        SefazServico.recepcaoEvento400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
      },
    },
    _ClusterNFe.svcAN: {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://www.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeInutilizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://hom.sefazvirtual.fazenda.gov.br/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
      },
    },
    _ClusterNFe.svcRS: {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
      },
    },
    _ClusterNFe.an: {
      Ambiente.producao: {
        SefazServico.nfeDistribuicaoDFe101:
            'https://www1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx',
        SefazServico.recepcaoEvento400:
            'https://www.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeDistribuicaoDFe101:
            'https://hom1.nfe.fazenda.gov.br/NFeDistribuicaoDFe/NFeDistribuicaoDFe.asmx',
        SefazServico.recepcaoEvento400:
            'https://hom1.nfe.fazenda.gov.br/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
      },
    },
  };

  // -------------------------------
  // Clusters (Virtual SEFAZ) - NFCe
  // -------------------------------

  static const Map<_ClusterNFCe, Map<Ambiente, Map<SefazServico, String>>>
  _nfceClusterEndpoints = {
    _ClusterNFCe.svrs: {
      Ambiente.producao: {
        SefazServico.nfeAutorizacao400:
            'https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfce-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
      },
    },
  };

  // -------------------------------
  // Mapeamento UF -> Cluster (NFe)
  // -------------------------------

  static const Map<String, _ClusterNFe> _nfeUfToCluster = {
    'AC': _ClusterNFe.svrs,
    'AL': _ClusterNFe.svrs,
    'AP': _ClusterNFe.svrs,
    'CE': _ClusterNFe.svrs,
    'DF': _ClusterNFe.svrs,
    'PA': _ClusterNFe.svrs,
    'PB': _ClusterNFe.svrs,
    'PI': _ClusterNFe.svrs,
    'RJ': _ClusterNFe.svrs,
    'RN': _ClusterNFe.svrs,
    'RO': _ClusterNFe.svrs,
    'RR': _ClusterNFe.svrs,
    'SC': _ClusterNFe.svrs,
    'SE': _ClusterNFe.svrs,
    'TO': _ClusterNFe.svrs,
    'ES': _ClusterNFe.svrs, // usa SVRS com override para CadConsultaCadastro
    'MA': _ClusterNFe.svcAN,
    'AN': _ClusterNFe.an,
  };

  // -------------------------------
  // Mapeamento UF -> Cluster (NFCe)
  // -------------------------------

  static const Map<String, _ClusterNFCe> _nfceUfToCluster = {
    'AC': _ClusterNFCe.svrs,
    'AL': _ClusterNFCe.svrs,
    'AP': _ClusterNFCe.svrs,
    'BA': _ClusterNFCe.svrs,
    'CE': _ClusterNFCe.svrs,
    'DF': _ClusterNFCe.svrs,
    'ES': _ClusterNFCe.svrs,
    'MA': _ClusterNFCe.svrs,
    'PA': _ClusterNFCe.svrs,
    'PB': _ClusterNFCe.svrs,
    'PI': _ClusterNFCe.svrs,
    'RJ': _ClusterNFCe.svrs,
    'RN': _ClusterNFCe.svrs,
    'RO': _ClusterNFCe.svrs,
    'RR': _ClusterNFCe.svrs,
    'SC': _ClusterNFCe.svrs,
    'SE': _ClusterNFCe.svrs,
    'TO': _ClusterNFCe.svrs,
  };

  // -------------------------------
  // Per-UF overrides (NFe)
  // -------------------------------

  static const Map<String, Map<Ambiente, Map<SefazServico, String>>>
  _nfeUfOverrides = {
    'AM': {
      Ambiente.producao: {
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.am.gov.br/services2/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.am.gov.br/services2/services/NfeStatusServico4',
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4',
      },
      Ambiente.homologacao: {
        SefazServico.nfeConsultaCadastro400:
            'https://homnfe.sefaz.am.gov.br/services2/services/CadConsultaCadastro4',
        SefazServico.nfeConsultaProtocolo400:
            'https://homnfe.sefaz.am.gov.br/services2/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://homnfe.sefaz.am.gov.br/services2/services/NfeStatusServico4',
        SefazServico.nfeInutilizacao400:
            'https://homnfe.sefaz.am.gov.br/services2/services/NfeInutilizacao4',
        SefazServico.nfeAutorizacao400:
            'https://homnfe.sefaz.am.gov.br/services2/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://homnfe.sefaz.am.gov.br/services2/services/NfeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://homnfe.sefaz.am.gov.br/services2/services/RecepcaoEvento4',
      },
    },
    'BA': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeAutorizacao4/NFeAutorizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeConsultaProtocolo4/NFeConsultaProtocolo4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeInutilizacao4/NFeInutilizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeRetAutorizacao4/NFeRetAutorizacao4.asmx',
        SefazServico.nfeStatusServico400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeStatusServico4/NFeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://hnfe.sefaz.ba.gov.br/webservices/NFeRecepcaoEvento4/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://hnfe.sefaz.ba.gov.br/webservices/CadConsultaCadastro4/CadConsultaCadastro4.asmx',
      },
    },
    'ES': {
      Ambiente.producao: {
        SefazServico.nfeConsultaCadastro400:
            'https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeConsultaCadastro400:
            'https://app.sefaz.es.gov.br/ConsultaCadastroService/CadConsultaCadastro2.asmx',
      },
    },
    'GO': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4?wsdl',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeInutilizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4?wsdl',
      },
    },
    'MG': {
      Ambiente.producao: {
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/CadConsultaCadastro4',
        SefazServico.nfeInutilizacao400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4',
        SefazServico.nfeAutorizacao400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://nfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4',
      },
      Ambiente.homologacao: {
        SefazServico.nfeConsultaCadastro400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/CadConsultaCadastro4',
        SefazServico.nfeAutorizacao400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeAutorizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeConsultaProtocolo4',
        SefazServico.nfeInutilizacao400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeInutilizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRetAutorizacao4',
        SefazServico.nfeStatusServico400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeStatusServico4',
        SefazServico.recepcaoEvento400:
            'https://hnfe.fazenda.mg.gov.br/nfe2/services/NFeRecepcaoEvento4',
      },
    },
    'MS': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeStatusServico4',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeRetAutorizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeStatusServico4',
        SefazServico.nfeInutilizacao400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeInutilizacao4',
        SefazServico.recepcaoEvento400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4',
        SefazServico.nfeConsultaCadastro400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4',
      },
    },
    'MT': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4?wsdl',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4?wsdl',
      },
      Ambiente.homologacao: {
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeRetAutorizacao4?wsdl',
        SefazServico.recepcaoEvento400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/RecepcaoEvento4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeConsulta4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeAutorizacao4?wsdl',
        SefazServico.nfeInutilizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeInutilizacao4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/CadConsultaCadastro4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://homologacao.sefaz.mt.gov.br/nfews/v2/services/NfeStatusServico4?wsdl',
      },
    },
    'PE': {
      Ambiente.producao: {
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4',
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4',
      },
      Ambiente.homologacao: {
        SefazServico.nfeInutilizacao400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/CadConsultaCadastro4',
        SefazServico.recepcaoEvento400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://nfehomolog.sefaz.pe.gov.br/nfe-service/services/NFeRetAutorizacao4?wsdl',
      },
    },
    'PR': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4?wsdl',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4?wsdl',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeInutilizacao400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/CadConsultaCadastro4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.nfe.sefa.pr.gov.br/nfe/NFeRetAutorizacao4?wsdl',
      },
    },
    'RS': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx',
      },
    },
    'SP': {
      Ambiente.producao: {
        SefazServico.nfeInutilizacao400:
            'https://nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx',
      },
      Ambiente.homologacao: {
        SefazServico.nfeInutilizacao400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeconsultaprotocolo4.asmx',
        SefazServico.nfeStatusServico400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfestatusservico4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nfeautorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferetautorizacao4.asmx',
        SefazServico.nfeConsultaCadastro400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/cadconsultacadastro4.asmx',
        SefazServico.recepcaoEvento400:
            'https://homologacao.nfe.fazenda.sp.gov.br/ws/nferecepcaoevento4.asmx',
      },
    },
  };

  // -------------------------------
  // Per-UF overrides (NFCe)
  // -------------------------------

  static const Map<String, Map<Ambiente, Map<SefazServico, String>>>
  _nfceUfOverrides = {
    'AM': {
      Ambiente.producao: {
        SefazServico.administrarCscNfce100:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/CscNFCe',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/NfeStatusServico4',
        SefazServico.nfeInutilizacao400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/NfeInutilizacao4',
        SefazServico.nfeAutorizacao400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/NfeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://nfce.sefaz.am.gov.br/nfce-services/services/RecepcaoEvento4',
        SefazServico.urlQrCode:
            'http://sistemas.sefaz.am.gov.br/nfceweb/consultarNFCe.jsp',
        SefazServico.urlConsultaNfce: 'www.sefaz.am.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.administrarCscNfce100:
            'https://homnfce.sefaz.am.gov.br/nfce-services/services/CscNFCe',
        SefazServico.nfeConsultaProtocolo400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/NfeStatusServico4',
        SefazServico.nfeInutilizacao400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/NfeInutilizacao4',
        SefazServico.nfeAutorizacao400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/NfeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://homnfce.sefaz.am.gov.br/nfce-services-nac/services/RecepcaoEvento4',
        SefazServico.urlQrCode:
            'https://sistemas.sefaz.am.gov.br/nfceweb-hom/consultarNFCe.jsp',
        SefazServico.urlConsultaNfce:
            'https://sistemas.sefaz.am.gov.br/nfceweb-hom/formConsulta.do',
      },
    },
    'GO': {
      Ambiente.producao: {
        SefazServico.recepcaoEvento400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeInutilizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://nfe.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4?wsdl',
        SefazServico.urlQrCode:
            'https://nfeweb.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe',
        SefazServico.urlConsultaNfce:
            'http://www.sefaz.go.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeRecepcaoEvento4?wsdl',
        SefazServico.nfeInutilizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeInutilizacao4?wsdl',
        SefazServico.nfeConsultaProtocolo400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeConsultaProtocolo4?wsdl',
        SefazServico.nfeStatusServico400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeStatusServico4?wsdl',
        SefazServico.nfeConsultaCadastro400:
            'https://homolog.sefaz.go.gov.br/nfe/services/CadConsultaCadastro4?wsdl',
        SefazServico.nfeAutorizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeAutorizacao4?wsdl',
        SefazServico.nfeRetAutorizacao400:
            'https://homolog.sefaz.go.gov.br/nfe/services/NFeRetAutorizacao4?wsdl',
        SefazServico.urlQrCode:
            'https://nfewebhomolog.sefaz.go.gov.br/nfeweb/sites/nfce/danfeNFCe',
        SefazServico.urlConsultaNfce:
            'http://www.sefaz.go.gov.br/nfce/consulta',
      },
    },
    'MG': {
      Ambiente.producao: {
        SefazServico.recepcaoEvento400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeRecepcaoEvento4',
        SefazServico.nfeInutilizacao400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeStatusServico4',
        SefazServico.nfeAutorizacao400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.fazenda.mg.gov.br/nfce/services/NFeRetAutorizacao4',
        SefazServico.urlQrCode:
            'https://portalsped.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml',
        SefazServico.urlConsultaNfce:
            'https://portalsped.fazenda.mg.gov.br/portalnfce',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeRecepcaoEvento4',
        SefazServico.nfeInutilizacao400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeStatusServico4',
        SefazServico.nfeAutorizacao400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://hnfce.fazenda.mg.gov.br/nfce/services/NFeRetAutorizacao4',
        SefazServico.urlQrCode:
            'https://portalsped.fazenda.mg.gov.br/portalnfce/sistema/qrcode.xhtml',
        SefazServico.urlConsultaNfce:
            'https://hportalsped.fazenda.mg.gov.br/portalnfce',
      },
    },
    'MS': {
      Ambiente.producao: {
        SefazServico.nfeAutorizacao400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4',
        SefazServico.recepcaoEvento400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4',
        SefazServico.nfeInutilizacao400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4',
        SefazServico.nfeStatusServico400:
            'https://nfce.sefaz.ms.gov.br/ws/NFeStatusServico4',
        SefazServico.nfeConsultaCadastro400:
            'https://nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4',
        SefazServico.urlQrCode: 'http://www.dfe.ms.gov.br/nfce/qrcode',
        SefazServico.urlConsultaNfce: 'http://www.dfe.ms.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeRetAutorizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeConsultaProtocolo4',
        SefazServico.nfeInutilizacao400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeInutilizacao4',
        SefazServico.nfeStatusServico400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeStatusServico4',
        SefazServico.recepcaoEvento400:
            'https://hom.nfce.sefaz.ms.gov.br/ws/NFeRecepcaoEvento4',
        SefazServico.nfeConsultaCadastro400:
            'https://hom.nfe.sefaz.ms.gov.br/ws/CadConsultaCadastro4',
        SefazServico.urlQrCode: 'http://www.dfe.ms.gov.br/nfce/qrcode',
        SefazServico.urlConsultaNfce: 'http://www.dfe.ms.gov.br/nfce/consulta',
      },
    },
    'MT': {
      Ambiente.producao: {
        SefazServico.recepcaoEvento400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/RecepcaoEvento4',
        SefazServico.nfeInutilizacao400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4',
        SefazServico.nfeAutorizacao400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4',
        SefazServico.urlQrCode: 'http://www.sefaz.mt.gov.br/nfce/consultanfce',
        SefazServico.urlConsultaNfce:
            'http://www.sefaz.mt.gov.br/nfce/consultanfce',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/RecepcaoEvento4',
        SefazServico.nfeInutilizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeInutilizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeConsulta4',
        SefazServico.nfeStatusServico400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeStatusServico4',
        SefazServico.nfeAutorizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.sefaz.mt.gov.br/nfcews/services/NfeRetAutorizacao4',
        SefazServico.urlQrCode:
            'http://homologacao.sefaz.mt.gov.br/nfce/consultanfce',
        SefazServico.urlConsultaNfce:
            'http://homologacao.sefaz.mt.gov.br/nfce/consultanfce',
      },
    },
    'PE': {
      Ambiente.producao: {
        SefazServico.urlQrCode:
            'http://nfce.sefaz.pe.gov.br/nfce-web/consultarNFCe',
        SefazServico.urlConsultaNfce: 'nfce.sefaz.pe.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.urlQrCode:
            'http://nfcehomolog.sefaz.pe.gov.br/nfce-web/consultarNFCe',
        SefazServico.urlConsultaNfce: 'nfce.sefaz.pe.gov.br/nfce/consulta',
      },
    },
    'PR': {
      Ambiente.producao: {
        SefazServico.nfeAutorizacao400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4',
        SefazServico.nfeInutilizacao400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4',
        SefazServico.nfeStatusServico400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeStatusServico4',
        SefazServico.recepcaoEvento400:
            'https://nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4',
        SefazServico.nfeConsultaCadastro400:
            'https://nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4',
        SefazServico.urlQrCode: 'http://www.fazenda.pr.gov.br/nfce/qrcode/',
        SefazServico.urlConsultaNfce:
            'http://www.fazenda.pr.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeAutorizacao4',
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRetAutorizacao4',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeConsultaProtocolo4',
        SefazServico.nfeInutilizacao400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeInutilizacao4',
        SefazServico.nfeStatusServico400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeStatusServico4',
        SefazServico.recepcaoEvento400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/NFeRecepcaoEvento4',
        SefazServico.nfeConsultaCadastro400:
            'https://homologacao.nfce.sefa.pr.gov.br/nfce/CadConsultaCadastro4',
        SefazServico.urlQrCode: 'http://www.fazenda.pr.gov.br/nfce/qrcode/',
        SefazServico.urlConsultaNfce:
            'http://www.fazenda.pr.gov.br/nfce/consulta',
      },
    },
    'RS': {
      Ambiente.producao: {
        SefazServico.nfeStatusServico400:
            'https://nfce.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfce.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfce.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfce.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.urlQrCode:
            'https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx',
        SefazServico.urlConsultaNfce: 'www.sefaz.rs.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.recepcaoEvento400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx',
        SefazServico.nfeAutorizacao400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce-homologacao.sefazrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx',
        SefazServico.urlQrCode:
            'https://www.sefaz.rs.gov.br/NFCE/NFCE-COM.aspx',
        SefazServico.urlConsultaNfce: 'www.sefaz.rs.gov.br/nfce/consulta',
      },
    },
    'SP': {
      Ambiente.producao: {
        SefazServico.nfeAutorizacao400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx',
        SefazServico.recepcaoEvento400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeStatusServico400:
            'https://nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx',
        SefazServico.urlQrCode: 'https://www.nfce.fazenda.sp.gov.br/qrcode',
        SefazServico.urlConsultaNfce:
            'https://www.nfce.fazenda.sp.gov.br/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.nfeAutorizacao400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeAutorizacao4.asmx',
        SefazServico.nfeRetAutorizacao400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRetAutorizacao4.asmx',
        SefazServico.nfeInutilizacao400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeInutilizacao4.asmx',
        SefazServico.nfeConsultaProtocolo400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeConsultaProtocolo4.asmx',
        SefazServico.recepcaoEvento400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeRecepcaoEvento4.asmx',
        SefazServico.nfeStatusServico400:
            'https://homologacao.nfce.fazenda.sp.gov.br/ws/NFeStatusServico4.asmx',
        SefazServico.urlQrCode:
            'https://www.homologacao.nfce.fazenda.sp.gov.br/qrcode',
        SefazServico.urlConsultaNfce:
            'https://www.homologacao.nfce.fazenda.sp.gov.br/consulta',
      },
    },
    'DF': {
      Ambiente.producao: {
        SefazServico.urlQrCode: 'https://www.fazenda.df.gov.br/nfce/qrcode',
        SefazServico.urlConsultaNfce: 'www.fazenda.df.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.urlQrCode: 'https://www.fazenda.df.gov.br/nfce/qrcode',
        SefazServico.urlConsultaNfce: 'www.fazenda.df.gov.br/nfce/consulta',
      },
    },
    'ES': {
      Ambiente.producao: {
        SefazServico.urlQrCode:
            'http://app.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx',
        SefazServico.urlConsultaNfce: 'www.sefaz.es.gov.br/nfce/consulta',
      },
      Ambiente.homologacao: {
        SefazServico.urlQrCode:
            'http://homologacao.sefaz.es.gov.br/ConsultaNFCe/qrcode.aspx',
        SefazServico.urlConsultaNfce: 'www.sefaz.es.gov.br/nfce/consulta',
      },
    },
  };

  // -------------------------------
  // Public API
  // -------------------------------

  /// Returns a full map of endpoints for [tipo]/[uf]/[ambiente],
  /// merging cluster fallback + overrides.
  static Map<SefazServico, String> getEndpoints({
    required TipoDocumento tipo,
    required String uf,
    required Ambiente ambiente,
  }) {
    final ufUpper = uf.toUpperCase();

    if (tipo == TipoDocumento.nfe) {
      return _getNFeEndpoints(ufUpper, ambiente);
    } else {
      return _getNFCeEndpoints(ufUpper, ambiente);
    }
  }

  /// Returns a single service URL if available.
  static String? getUrl({
    required TipoDocumento tipo,
    required String uf,
    required Ambiente ambiente,
    required SefazServico servico,
  }) {
    final endpoints = getEndpoints(tipo: tipo, uf: uf, ambiente: ambiente);
    return endpoints[servico];
  }

  // -------------------------------
  // Private Helper Methods
  // -------------------------------

  static Map<SefazServico, String> _getNFeEndpoints(
    String uf,
    Ambiente ambiente,
  ) {
    // Start with cluster base
    final cluster = _nfeUfToCluster[uf];
    final base = <SefazServico, String>{};
    if (cluster != null) {
      final clusterEndpoints = _nfeClusterEndpoints[cluster]?[ambiente];
      if (clusterEndpoints != null) {
        base.addAll(clusterEndpoints);
      }
    }

    // Apply UF-specific overrides
    if (_nfeUfOverrides.containsKey(uf)) {
      final overrides = _nfeUfOverrides[uf]?[ambiente];
      if (overrides != null) {
        base.addAll(overrides);
      }
    }

    if (base.isEmpty) {
      throw ArgumentError('Sem endpoints configurados para NFe $uf/$ambiente');
    }

    return base;
  }

  static Map<SefazServico, String> _getNFCeEndpoints(
    String uf,
    Ambiente ambiente,
  ) {
    // Start with cluster base
    final cluster = _nfceUfToCluster[uf];
    final base = <SefazServico, String>{};
    if (cluster != null) {
      final clusterEndpoints = _nfceClusterEndpoints[cluster]?[ambiente];
      if (clusterEndpoints != null) {
        base.addAll(clusterEndpoints);
      }
    }

    // Apply UF-specific overrides
    if (_nfceUfOverrides.containsKey(uf)) {
      final overrides = _nfceUfOverrides[uf]?[ambiente];
      if (overrides != null) {
        base.addAll(overrides);
      }
    }

    if (base.isEmpty) {
      throw ArgumentError('Sem endpoints configurados para NFCe $uf/$ambiente');
    }

    return base;
  }
}

void verificarDisponibilidade(String uf, TipoDocumento tipo) {
  try {
    final endpoints = SefazEndpoints.getEndpoints(
      tipo: tipo,
      uf: uf,
      ambiente: Ambiente.producao,
    );

    print('✅ $uf suporta ${tipo.name.toUpperCase()}');
    print('Serviços disponíveis: ${endpoints.keys.length}');

    // Verificar serviços essenciais
    final servicosEssenciais = [
      SefazServico.nfeAutorizacao400,
      SefazServico.nfeConsultaProtocolo400,
      SefazServico.nfeStatusServico400,
      SefazServico.recepcaoEvento400,
    ];

    for (final servico in servicosEssenciais) {
      final disponivel = endpoints.containsKey(servico);
      print('  $servico: ${disponivel ? "✓" : "✗"}');
    }
  } catch (e) {
    print('❌ $uf não suporta ${tipo.name.toUpperCase()}: $e');
  }
}
