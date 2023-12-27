import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String paraDataString() => DateFormat('yyyy-MM-dd').format(this);
  String paraDataStringUtc() => DateFormat('yyyy-MM-ddTHH:mm:sszzz').format(this);
}