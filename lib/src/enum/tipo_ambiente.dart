enum ETipoAmbiente {
  producao("Produção", "1"),
  homologacao("Homologação", "2");

  final String description;
  final String xmlValue;
  const ETipoAmbiente(this.description, this.xmlValue);
}