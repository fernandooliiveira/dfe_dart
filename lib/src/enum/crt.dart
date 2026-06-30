enum ECrt {
  simplesNacional("Simples Nacional", "1"),
  simplesNacionalExcesso("Simples Nacional - excesso de sublimite", "2"),
  regimeNormal("Regime Normal", "3"),
  mei("Simples Nacional - MEI", "4");

  const ECrt(this.description, this.xmlValue);

  final String description;
  final String xmlValue;
}
