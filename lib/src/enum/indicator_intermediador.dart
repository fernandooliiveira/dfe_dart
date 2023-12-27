enum EIndicadorIntermediador {
  iiSemIntermediador("Operação sem intermediador (em site ou plataforma própria)", "0"),
  iiSitePlataformaTerceiros("Operação em site ou plataforma de terceiros (intermediadores / marketplace)", "1");

  final String description;
  final String xmlEnum;

  const EIndicadorIntermediador(this.description, this.xmlEnum);
}
