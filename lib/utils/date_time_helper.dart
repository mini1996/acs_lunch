import 'package:intl/intl.dart';

class DateTimeHelper {
  static getCurrentDateTime() {
    var now = new DateTime.now();
    return now;
  }

  static getCurrentTimeInMilliSeconds() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static getDateTimeFromMilliSeconds(milliSeconds) {
    // return timeago.format(DateTime.fromMillisecondsSinceEpoch(milliSeconds),
    //     locale: 'fr_short');
    // return DateFormat.yMd()
    //     .add_jm()
    //     .format(DateTime.fromMillisecondsSinceEpoch(milliSeconds));
    return DateTime.fromMillisecondsSinceEpoch(milliSeconds).toString();
  }

  static getReadableDateTimeFromMilliseconds(milliSeconds) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(milliSeconds);
    final dateToCheck = DateTime(date.year, date.month, date.day);
    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateToCheck == today) {
      return DateFormat.jm().format(date);
    } else {
      return DateFormat.yMd().format(date);
    }
  }

  static getMilliSecondsFromUtc(utcString) {
    if (utcString == null) return null;
    return DateTime.parse(utcString).millisecondsSinceEpoch;
  }
}
