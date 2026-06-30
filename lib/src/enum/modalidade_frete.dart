enum EModalidadeFrete {
  porContaEmitente("Por conta do Emitente (CIF)", "0"),
  porContaDestinatario("Por conta do Destinatário/Remetente (FOB)", "1"),
  porContaTerceiros("Por conta de Terceiros", "2"),
  proprio("Próprio por conta do Remetente", "3"),
  proprioDestinatario("Próprio por conta do Destinatário", "4"),
  semFrete("Sem Ocorrência de Transporte", "9");

  const EModalidadeFrete(this.description, this.xmlValue);

  final String description;
  final String xmlValue;
}
