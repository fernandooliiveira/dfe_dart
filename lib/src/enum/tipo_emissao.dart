enum ETipoEmissao {
  teNormal("Normal", "1"),
  teFSIA("Contingência FS-IA", "2"),
  teSCAN("Contingência SCAN", "3"),
  teEPEC("Contingência DPEC", "4"),
  teFSDA("Contingência FS-DA", "5"),
  teSVCAN("Contingência SVC-AN", "6"),
  teSVCRS("Contingência SVC-RS", "7"),
  teOffLine("Contingência off-line", "9");

  final String description;
  final String xmlEnum;
  const ETipoEmissao(this.description, this.xmlEnum);
}
