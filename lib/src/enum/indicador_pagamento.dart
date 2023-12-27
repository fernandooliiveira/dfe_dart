enum EIndicadorPagamento {
  ipVista("Pagamento à vista", "0"),
  ipPrazo("Pagamento à prazo", "1"),
  ipOutras("Outros", "2");

  final String description;
  final String name;
  const EIndicadorPagamento(this.description, this.name);
}