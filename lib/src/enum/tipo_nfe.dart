enum ETipoNfe {
  tnEntrada("Entrada", "0"),
  tnSaida("Saída", "1");

  final String description;
  final String xmlValue;
  const ETipoNfe(this.description, this.xmlValue);
}