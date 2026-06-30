import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String paraDataString() => DateFormat('yyyy-MM-dd').format(this);

  /// Formato ISO 8601 com offset de fuso horário local: yyyy-MM-ddTHH:mm:ss±HH:MM
  /// Exigido pelo schema da NF-e/NFC-e (ex: 2024-01-15T10:30:00-03:00)
  String paraDataStringNfe() {
    final offset = timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hh = offset.inHours.abs().toString().padLeft(2, '0');
    final mm = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    return '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(this)}$sign$hh:$mm';
  }
}
