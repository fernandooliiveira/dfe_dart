enum EVersaoQrCode {
  qrCodeVersao1("Versão 1.0 do QR-Code", 100),
  qrCodeVersao2("Versão 2.0 do QR-Code", 2);

  final String description;
  final int value;

  const EVersaoQrCode(this.description, this.value);
}