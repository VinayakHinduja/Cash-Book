import 'package:intl/intl.dart';

class Time {
  static String getFormatted(DateTime time) =>
      DateFormat("d MMMM, yyyy").add_jm().format(time);

  static int getRawTime(DateTime time) =>
      DateTime.utc(time.year, time.month, time.day, time.hour, time.minute)
          .millisecondsSinceEpoch;
}
