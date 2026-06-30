enum EIndicadorIEDest {
  contribuinteICMS("Contribuinte ICMS", "1"),
  contribuinteIsento("Contribuinte isento de Inscrição", "2"),
  naoContribuinte("Não Contribuinte", "9");

  const EIndicadorIEDest(this.description, this.xmlValue);

  final String description;
  final String xmlValue;
}
