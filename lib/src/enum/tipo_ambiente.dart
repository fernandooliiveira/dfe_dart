enum ETipoAmbiente {
  producao("Produção", "1"),
  homologacao("Homologação", "2");

  final String description;
  final String name;
  const ETipoAmbiente(this.description, this.name);
}