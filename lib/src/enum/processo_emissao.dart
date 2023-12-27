enum ProcessoEmissao {
  peAplicativoContribuinte("Emissão de NF-e com aplicativo do contribuinte", "0"),
  peAvulsaFisco("Emissão de NF-e avulsa pelo Fisco", "1"),
  peAvulsaContribuinte("Emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco", "2"),
  peContribuinteAplicativoFisco("Emissão de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco", "3");

  final String description;
  final String xmlEnum;

  const ProcessoEmissao(this.description, this.xmlEnum);
}
