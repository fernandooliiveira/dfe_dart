enum ETipoUrlConsultaPublica {
  urlConsulta("Endereço para consulta da NFCe através do site"),
  urlQrCode("Endereço para consulta da NFCe através do QR-Code");

  final String description;
  const ETipoUrlConsultaPublica(this.description);
}