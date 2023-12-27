enum EFinalidadeNFe {
  fnNormal("NFe normal", "1"),
  fnComplementar("NFe complementar", "2"),
  fnAjuste("NFe de ajuste", "3"),
  fnDevolucao("Devolução de mercadoria", "4");

  final String description;
  final String xmlEnum;
  const EFinalidadeNFe(this.description, this.xmlEnum);
}
