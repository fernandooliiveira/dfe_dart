enum EDestinoOperacao {
  doInterna("Operação interna", "1"),
  doInterestadual("Operação interestadual", "2"),
  doExterior("Operação com exterior", "3");

  final String description;
  final String xmlValue;
  const EDestinoOperacao(this.description, this.xmlValue);
}