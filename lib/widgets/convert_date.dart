import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ConvertDate {
  ConvertDate(
    this.context,
  ) {
    initializeDateFormatting();
  }

  final BuildContext context;

  int secondsFromDate(DateTime date) {
    var time = date.toLocal().millisecondsSinceEpoch ~/ 1000;
    return time;
  }

  int secondsSinceDayBegin(DateTime date) {
    var time = (dayBegin().millisecondsSinceEpoch ~/ 1000);
    return (date.toLocal().millisecondsSinceEpoch ~/ 1000) - time;
  }

  static DateTime dayBegin() {
    var date = DateTime.now().toLocal();
    return date.add(
      Duration(
        hours: -date.hour,
        minutes: -date.minute,
        seconds: -date.second,
        milliseconds: -date.millisecond,
        microseconds: -date.microsecond,
      ),
    );
  }

  static DateTime dayBeginFrom(int time) {
    var date = dateFromSeconds(time);
    return date.add(
      Duration(
        hours: -date.hour,
        minutes: -date.minute,
        seconds: -date.second,
        milliseconds: -date.millisecond,
        microseconds: -date.microsecond,
      ),
    );
  }

  static int dayBeginInSeconds() {
    return dayBegin().millisecondsSinceEpoch ~/ 1000;
  }

  static DateTime dateFromSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toLocal();
  }

  static DateTime dateWithHoursAndMinutes(int hours, int minutes) {
    var time = dayBegin();
    return time.add(
      Duration(
        hours: hours,
        minutes: minutes,
      ),
    );
  }

  String fromUnix(int unix, String format) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
      unix * 1000,
    ).toLocal();
    Localizations.localeOf(context).languageCode;
    final DateFormat formatter = DateFormat(format, "ru");
    return formatter.format(date);
  }

  String fromDate(DateTime date, String format) {
    Localizations.localeOf(context).languageCode;
    final DateFormat formatter = DateFormat(format, "ru");
    return formatter.format(date.toLocal());
  }
}
