enum EPresencaComprador {
  pcNao("Não se aplica", "0"),
  pcPresencial("Operação presencial", "1"),
  pcInternet("Operação não presencial, pela Internet", "2"),
  pcTeleatendimento("Operação não presencial, Teleatendimento", "3"),
  pcEntregaDomicilio("NFC-e em operação com entrega a domicílio", "4"),
  pcPresencialForaEstabelecimento("Operação presencial, fora do estabelecimento", "5"),
  pcOutros("Operação não presencial, outros", "9");

  final String description;
  final String xmlEnum;

  const EPresencaComprador(this.description, this.xmlEnum);
}
