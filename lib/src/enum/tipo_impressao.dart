enum ETipoImpressao {
  tiSemGeracao("Sem DANFE", "0"),
  tiRetrato("DANFe Retrato", "1"),
  tiPaisagem("DANFe Paisagem", "2"),
  tiSimplificado("DANFe Simplificado", "3"),
  tiNFCe("DANFe NFC-e", "4"),
  tiMsgEletronica("DANFe NFC-e em mensagem eletrônica", "5");

  final String description;
  final String xmlEnum;
  const ETipoImpressao(this.description, this.xmlEnum);
}
