import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime get now => DateTime.now();

// start and end of today
DateTime get startOfToday => DateTime(now.year, now.month, now.day);
DateTime get endOfToday => DateTime(now.year, now.month, now.day, 23, 59, 59);

// start of day in dt
DateTime startOfDay(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
DateTime endOfDay(DateTime dt) =>
    DateTime(dt.year, dt.month, dt.day, 23, 59, 59);
// start and end of ago days ago
DateTime startOfDayAgo(int ago) => DateTime(now.year, now.month, now.day - ago);
DateTime endOfDayAgo(int ago) =>
    DateTime(now.year, now.month, now.day - ago, 23, 59, 59);

// default formats of time, date and datetime
DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');
DateFormat dateTimeWsFormat = DateFormat('yyyy-MM-dd-HH-mm-ss');
DateFormat dateFormat = DateFormat('dd/MM/yyyy');
DateFormat timeFormat = DateFormat('HH:mm');
DateFormat onlyHourFormat = DateFormat('HH');
DateFormat onlyMinuteFormat = DateFormat('mm');

// default string formatting of time, date and datetime
String dateTimeString(DateTime? date) =>
    date != null ? dateTimeFormat.format(date) : "--/--/-- --:--";
String dateTimeWsString(DateTime? date) =>
    date != null ? dateTimeWsFormat.format(date) : '????-??-??-??-??-??';
String timeString(DateTime? date) =>
    date != null ? timeFormat.format(date) : '--:--';
String dateString(DateTime? date) =>
    date != null ? dateFormat.format(date) : "--/--/--";
// get minutes from hours and minutes
getMinutes({hours, minutes}) => hours * 60 + minutes;

// compare only dates of two datetimes
extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

int upperMultiple(num from, int base) {
  return (from / base).ceil() * base;
}

extension DateTimeAndTimeOfDayCombine on DateTime {
  DateTime combine(TimeOfDay? time) =>
      DateTime(year, month, day, time?.hour ?? 0, time?.minute ?? 0);
}

int daysOfMonth(DateTime dt) => DateTime(dt.year, dt.month + 1, 0).day;
