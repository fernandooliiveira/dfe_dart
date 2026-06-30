/// Serviços SOAP disponíveis no WebService da SEFAZ para NFC-e.
enum ETipoServicoSefaz {
  nfceAutorizacao('NfceAutorizacao4', 'NfceAutorizacao4'),
  nfceRetAutorizacao('NfceRetAutorizacao4', 'NfceRetAutorizacao4'),
  nfeStatusServico('NFeStatusServico4', 'NFeStatusServico4'),
  nfeConsultaProtocolo('NFeConsultaProtocolo4', 'NFeConsultaProtocolo4'),
  nfeRecepcaoEvento('NFeRecepcaoEvento4', 'NFeRecepcaoEvento4'),
  nfeInutilizacao('NFeInutilizacao4', 'NFeInutilizacao4');

  /// Nome do serviço no WSDL (usado no namespace e no envelope SOAP).
  final String wsdlName;

  /// Nome do serviço no WSDL (alias, para legibilidade).
  final String label;

  const ETipoServicoSefaz(this.wsdlName, this.label);

  String get namespace =>
      'http://www.portalfiscal.inf.br/nfe/wsdl/$wsdlName';
}
