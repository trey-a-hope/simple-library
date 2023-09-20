import 'package:intl/intl.dart';

extension DateFormatExtensions on DateTime {
  String formatMMMddyyyy() => DateFormat('MMM dd, yyyy').format(this);
}
