import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('d MMMM y, H:mm a').format(dateTime);
  }
}
