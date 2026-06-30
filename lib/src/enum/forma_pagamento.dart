enum EFormaPagamento {
  dinheiro("Dinheiro", "01"),
  cheque("Cheque", "02"),
  cartaoCredito("Cartão de Crédito", "03"),
  cartaoDebito("Cartão de Débito", "04"),
  creditoLoja("Crédito Loja", "05"),
  valeAlimentacao("Vale Alimentação", "10"),
  valeRefeicao("Vale Refeição", "11"),
  valePresente("Vale Presente", "12"),
  valeCombustivel("Vale Combustível", "13"),
  boleto("Boleto Bancário", "15"),
  depositoBancario("Depósito Bancário", "16"),
  pix("Pix", "17"),
  transferencia("Transferência bancária", "18"),
  programaFidelidade("Programa de fidelidade", "19"),
  semPagamento("Sem Pagamento", "90"),
  outros("Outros", "99");

  const EFormaPagamento(this.description, this.xmlValue);

  final String description;
  final String xmlValue;
}
