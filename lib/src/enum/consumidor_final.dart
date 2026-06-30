enum EConsumidorFinal {
  cfNao("Normal", "0"),
  cfConsumidorFinal("Consumidor final", "1");

  final String description;
  final String xmlValue;
  const EConsumidorFinal(this.description, this.xmlValue);
}
