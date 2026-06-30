/// Resposta base de qualquer serviço SEFAZ.
class RetornoSefazBase {
  /// Código de status da SEFAZ (ex.: 100 = autorizado, 107 = serviço em operação).
  final int cStat;

  /// Descrição textual do status.
  final String xMotivo;

  /// Código UF da SEFAZ que processou.
  final String cUF;

  /// Data/hora do recebimento pelo SEFAZ.
  final String dhRecbto;

  /// Versão do aplicativo da SEFAZ.
  final String verAplic;

  const RetornoSefazBase({
    required this.cStat,
    required this.xMotivo,
    required this.cUF,
    required this.dhRecbto,
    required this.verAplic,
  });

  bool get autorizado => cStat == 100;
  bool get processado => cStat == 104;
  bool get duplicata => cStat == 204;
  bool get denegado => cStat == 110;

  @override
  String toString() => 'cStat=$cStat xMotivo=$xMotivo';
}
