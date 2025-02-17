import 'package:flutter/foundation.dart';

import 'stringify.dart';
import 'time.dart';

class RecurrencePattern {
  // Fields

  // time unit of recurrence: variable, getter, setter, static, readables
  String _interval;
  String get interval => _interval;
  // every count days
  static const String d = 'd';
  // every count weeks on weekDays
  static const String w = 'w';
  // every count month on monthDay
  static const String m = 'm';
  // every count month on weekDay of the weekNumber week of the month
  static const String n = 'n';
  // every count years
  static const String y = 'y';
  static final List<String> intervalList = [d, w, m, n, y];
  static final List<String> intervalReadableList = [
    'day',
    'week',
    'month',
    'year'
  ];
  static final Map<String, String> _intervalReadable = {
    d: intervalReadableList[0],
    w: intervalReadableList[1],
    m: intervalReadableList[2],
    n: intervalReadableList[2],
    y: intervalReadableList[3],
  };
  String get intervalReadable => _intervalReadable[_interval]!;
  String? intervalFromReadable(String readable) =>
      _intervalReadable.containsValue(readable)
          ? _intervalReadable.entries
              .firstWhere((element) => element.value == readable)
              .key
          : null;
  bool setInterval(String newInterval, DateTime startDate) {
    if (_interval == newInterval) return true;
    if (!intervalList.contains(newInterval)) {
      return false;
    }
    switch (_interval) {
      case w:
        _weekDays = null;
        break;
      case n:
        _weekDay = null;
        _weekNumber = null;
        break;
      case m:
        _monthDay = null;
        break;
    }
    switch (newInterval) {
      case w:
        _weekDays = [startDate.weekday];
        break;
      case n:
        _weekDay = startDate.weekday;
        _weekNumber = weekNumberFromDate(
                    MonthDirectionChoice.forward(), startDate) <=
                maxWeekNumber
            ? weekNumberFromDate(MonthDirectionChoice.forward(), startDate)
            : weekNumberFromDate(MonthDirectionChoice.backward(), startDate);
        break;
      case m:
        _monthDay = startDate.day;
        break;
      default:
        break;
    }
    _interval = newInterval;
    return true;
  }

  bool setIntervalFromReadable(String newInterval, DateTime startDate) =>
      intervalFromReadable(newInterval) != null
          ? setInterval(intervalFromReadable(newInterval)!, startDate)
          : false;

  // number of intervals (as time units): variable, getter, setter
  int _count;
  int get count => _count;
  set count(c) => _count = c;

  // when the recurrence stops:
  // variable, getter, setter, toInt, isBefore, static,
  DateTime _lastStart; // DT
  int get lastStartInt => _lastStart.millisecondsSinceEpoch;
  int get dbLastStart => lastStartInt;
  // static final neverEnds = DateTime.fromMillisecondsSinceEpoch(0);
  // bool isBeforeLastOccurrence(DateTime dt) {
  //  return _lastOccurrence.compareTo(neverEnds) == 0 ||
  //    dt.isBefore(_lastOccurrence);
  // }

  // void setNoLastOccurrence() => _lastOccurrence = neverEnds;
  void setLastStartByDate(DateTime lastDate) => _lastStart = lastDate;
  void setLastStartByOccurrences(DateTime startDate, int occurrences) =>
      _lastStart = stepForced(startDate, n: occurrences);

  // ONLY 'w' - list of days of the week [1 ... 7] oredered:
  // variable, getter, setter, static and readables
  List<int>? _weekDays; // se 'w'
  List<int>? get weekDays => _weekDays;
  set weekDaysOnly(int day) =>
      day > 0 && day < 8 ? _weekDays = [day] : _weekDays = _weekDays;
  static List<String> allWeekDaysE = [
    for (var index = 1; index < 8; index++) ...[weekDaysShort(index)]
  ];
  static List<String> allWeekDaysEEEE = [
    for (var index = 1; index < 8; index++) ...[weekDaysLong(index)]
  ];
  String get weekDaysReadable {
    String ret = '';
    if (_weekDays == null) {
      return ret;
    }
    if (listEquals(_weekDays, [1, 2, 3, 4, 5])) {
      ret += ' on workdays';
    } else if (listEquals(_weekDays, [1, 2, 3, 4, 5, 6, 7])) {
      ret += ' all the week';
    } else if (listEquals(_weekDays, [6, 7])) {
      ret += ' on weekends';
    } else if (_weekDays!.length == 1) {
      ret += ' on ${weekDaysLong(_weekDays!.first)}s';
    } else {
      ret += ' on ${weekDaysShort(_weekDays!.first)}';
      for (var element in _weekDays!.skip(1)) {
        ret += ', ${weekDaysShort(element)}';
      }
    }
    return ret;
  }

  void onWeekDaysTap(int day) {
    if (_weekDays == null) return;
    if (_weekDays!.contains(day)) {
      if (_weekDays!.length > 1) {
        _weekDays!.removeWhere((element) => element == day);
      }
    } else {
      _weekDays!.add(day);
      _weekDays!.sort();
    }
  }

  // [sun, mon, ..., sat]
  List<bool> get weekDaysSelected =>
      List.generate(7, (i) => _weekDays!.contains(i == 0 ? 7 : i));

  // ONLY 'm' - day of month, if non positive 0 last, -1 secondlast ...:
  // variable, getter,, setter
  int? _monthDay; // se 'm'
  int? get monthDay => _monthDay;
  static const int maxMonthDay = 31;
  static const int minMonthDay = -28;
  set monthDay(int? day) =>
      (day != null && day >= minMonthDay && day <= maxMonthDay)
          ? _monthDay = day
          : _monthDay = null;

  // ONLY 'n'- day of the week [1 ... 7]
  int? _weekDay; // se 'n'
  int? get weekDay => _weekDay;

  static const int minWeekDay = 1;
  static const int maxWeekDay = 7;
  set weekDay(int? day) => day != null && day >= minWeekDay && day <= maxWeekDay
      ? _weekDay = day
      : _weekDay = null;

  // ONLY 'n' - week of the month, if negative -1 last, -2 secondlast ...
  int? _weekNumber; // se 'n'
  int? get weekNumber => _weekNumber;
  static const int minWeekNumber = -3;
  static const int maxWeekNumber = 3;
  set weekNumber(int? n) =>
      n != null && n >= minWeekNumber && n <= maxWeekNumber
          ? _weekNumber = n
          : _weekNumber = null;

  // constructor and factories
  RecurrencePattern({
    required String interval,
    required int count,
    required DateTime lastStart,
    List<int>? weekDays,
    int? monthDay,
    int? weekDay,
    int? weekNumber,
  })  :
        // valid interval
        assert(_intervalReadable.keys.contains(interval)),
        // if 'w' => valid weekDays
        assert(interval != 'w' ||
            weekDays != null &&
                weekDays.isNotEmpty &&
                weekDays.skipWhile((value) => value > 0 && value < 8).isEmpty),
        // if 'm' => valid monthDay
        assert(interval != 'm' ||
            monthDay != null && monthDay > -29 && monthDay < 32),
        // if 'n' => valid weekDay and weekNumber
        assert(interval != 'n' ||
            (weekDay != null &&
                weekDay > 0 &&
                weekDay < 8 &&
                weekNumber != null &&
                weekNumber > -3 &&
                weekNumber < 5)),
        // initialize fields
        _interval = interval,
        _count = count,
        _lastStart = lastStart,
        _weekDays = weekDays,
        _monthDay = monthDay,
        _weekDay = weekDay,
        _weekNumber = weekNumber;

  static RecurrencePattern fromMap(Map map) {
    return RecurrencePattern(
      interval: map['interval'],
      count: map['count'],
      lastStart: DateTime.fromMillisecondsSinceEpoch(map['lastStart']),
      weekDay: int.tryParse(map['weekDay']),
      weekDays: (map['weekDays'] as String?)
          ?.split(',')
          .map((e) => int.parse(e))
          .toList(),
      monthDay: int.tryParse(map['monthDay']),
      weekNumber: int.tryParse(map['weekNumber']),
    );
  }

  Map<String, dynamic> toMap() => {
        'interval': interval,
        'count': count,
        'lastStart': dbLastStart,
        if (interval == n) 'weekDay': weekDay!,
        if (interval == w) 'weekDays': (weekDays!.map((e) => '$e')).join(','),
        if (interval == m) 'monthDay': monthDay!,
        if (interval == n) 'weekNumber': weekNumber!,
      };

  // factory RecurrencePattern.unlimited({
  //  required String interval,
  //  required int count,
  //  List<int>? weekDays,
  //  int? monthDay,
  //  int? weekDay,
  //  int? weekNumber,
  // }) =>
  //   RecurrencePattern(
  //     interval: interval,
  //     count: count,
  //     lastStart: neverEnds,
  //     weekDays: weekDays,
  //     weekDay: weekDay,
  //     weekNumber: weekNumber,
  //     monthDay: monthDay);

  factory RecurrencePattern.daily({DateTime? lastStart}) {
    return RecurrencePattern(
        interval: 'd',
        count: 1,
        lastStart: lastStart ?? DateTime(now.year + 2));
  }

  // stringify and readables
  String get recurrence => toString();

  @override
  String toString() {
    String ret = '$_interval, $_count, ${_lastStart.millisecondsSinceEpoch}';
    if (_interval == 'w') {
      ret += ', ${_weekDays!.toString()}';
    } else if (_interval == 'm') {
      ret += ', $_monthDay';
    } else if (_interval == 'n') {
      ret += ', $_weekDay, $_weekNumber';
    }
    return ret;
  }

  String get readable {
    String ret = 'Repeats';
    ret += _count == 1
        ? ' ${_intervalReadable[_interval]}ly'
        : ' every $_count ${_intervalReadable[_interval]}s';
    if (_interval == 'w') {
      ret += ' $weekDaysReadable';
    }
    if (_interval == 'n') {
      ret +=
          ' on every ${ordinal(_weekNumber! >= 0 ? _weekNumber! + 1 : -_weekNumber!)} ${weekDaysLong(_weekDay!)}';
    }
    if (_lastStart.millisecondsSinceEpoch != 0) {
      '. Until ${dateString(_lastStart)}';
    }
    return ret;
  }

  // monthly recurrece choices
  static int weekNumberFromDate(MonthDirectionChoice c, DateTime dt) =>
      c.forward ? dt.day ~/ 7 : -((daysOfMonth(dt) - dt.day) ~/ 7 + 1);
  static int monthDayFromDate(MonthDirectionChoice c, DateTime dt) =>
      c.forward ? dt.day : -(daysOfMonth(dt) - dt.day);

  MonthDirectionChoice get monthChoice => MonthDirectionChoice(
      interval: _interval,
      forward: interval == m
          ? monthDay! > 0
              ? true
              : false
          : interval == n
              ? weekNumber! >= 0
                  ? true
                  : false
              : true);

  bool changeMonthChoice(MonthDirectionChoice choice, DateTime startDate) {
    if (setInterval(choice.interval, startDate)) {
      if (choice.interval == m) {
        _monthDay = weekNumberFromDate(choice, startDate);
        return true;
      } else {
        _weekDay = startDate.weekday;
        _weekNumber = weekNumberFromDate(choice, startDate);
        return true;
      }
    }
    return false;
  }

  static String monthChoiceReadable(
      MonthDirectionChoice choice, DateTime startDate) {
    if (choice.interval == m) {
      if (choice.forward) {
        return 'on day ${startDate.day}';
      } else if (daysOfMonth(startDate) == startDate.day) {
        return 'on the last day';
      } else {
        return 'on the ${ordinal(-monthDayFromDate(choice, startDate) + 1)} last day';
      }
    } else {
      if (choice.forward) {
        return 'on the ${ordinal(weekNumberFromDate(choice, startDate) + 1)} ${weekDaysLong(startDate.weekday)}';
      } else if (weekNumberFromDate(choice, startDate) == -1) {
        return 'on the last ${weekDaysLong(startDate.weekday)}';
      } else {
        return 'on the ${ordinal(-weekNumberFromDate(choice, startDate))} last ${weekDaysLong(startDate.weekday)}';
      }
    }
  }

  static List<MonthDirectionChoice> monthChoices = [
    MonthDirectionChoice(interval: m, forward: true),
    MonthDirectionChoice(interval: m, forward: false),
    MonthDirectionChoice(interval: n, forward: true),
    MonthDirectionChoice(interval: n, forward: false),
  ];

  static List<MonthDirectionChoice> monthChoicesAvailable(DateTime startDate) {
    return [
      monthChoices[0],
      if (startDate.day - daysOfMonth(startDate) >= minMonthDay)
        monthChoices[1],
      if (weekNumberFromDate(monthChoices[2], startDate) >= minWeekNumber)
        monthChoices[2],
      if (weekNumberFromDate(monthChoices[3], startDate) >= minWeekNumber)
        monthChoices[3],
    ];
  }

  // steps and rightAfter
  int daysWeeklyStep(int d, {int n = 1}) {
    if (d < 1 || d > 7 || weekDays == null) return 0;
    int w = _count * (n ~/ weekDays!.length);
    n = n % weekDays!.length;
    // index of d or right after d, -1 if d > weekDays.last
    int startIndex = weekDays!.indexWhere((elem) => elem >= d);
    int finalIndex = startIndex == -1 ? n : (startIndex + n) % weekDays!.length;
    return (weekDays![finalIndex] - d >= 0)
        ? (weekDays![finalIndex] - d) + w * 7
        : (weekDays![finalIndex] - d) + (w + _count) * 7;
  }

  DateTime stepForced(DateTime dt, {int n = 1}) {
    switch (_interval) {
      case 'd':
        return dt.add(Duration(days: _count * n));
      case 'w':
        if (!_weekDays!.contains(dt.weekday)) {
          return dt;
        }
        return dt.add(Duration(days: daysWeeklyStep(dt.weekday, n: n)));
      case 'm':
        if (_monthDay! < 1) {
          return DateTime(dt.year, dt.month + _count * n + 1, _monthDay!,
              dt.hour, dt.minute);
        } else if (_monthDay! > 28) {
          var d = DateTime(
              dt.year, dt.month + _count * n + 1, 0, dt.hour, dt.minute);
          if (d.day > _monthDay!) {
            d.subtract(Duration(days: d.day - _monthDay!));
          }
          return d;
        } else {
          return DateTime(
              dt.year, dt.month + _count * n, _monthDay!, dt.hour, dt.minute);
        }
      case 'n':
        if (_weekNumber! >= 0) {
          var d =
              DateTime(dt.year, dt.month + _count * n, 1, dt.hour, dt.minute);
          int delta = (_weekDay! - d.weekday) % 7 + _weekNumber! * 7;
          return d.add(Duration(days: delta));
        } else {
          var d = DateTime(
              dt.year, dt.month + _count * n + 1, 0, dt.hour, dt.minute);
          int delta = (_weekNumber! + 1) * 7 - (d.weekday - _weekDay!) % 7;
          return d.add(Duration(days: delta));
        }
      case 'y':
        return DateTime(
            dt.year + _count * n,
            dt.month,
            (dt.day == 29 && dt.month == 2 && (dt.year + _count * n) % 4 == 0)
                ? 28
                : dt.day,
            dt.hour,
            dt.minute);
      default:
        return dt;
    }
  }

  DateTime? step(DateTime dt, {int n = 1}) {
    var ret = stepForced(dt, n: n);
    if (_lastStart.isAfter(ret)) {
      return ret;
    }
    return null;
  }

  DateTime? rightAfter(DateTime startRecurrence, DateTime dateBefore) {
    DateTime srDate = startOfDay(startRecurrence);
    DateTime dbDate = startOfDay(dateBefore);
    if (_lastStart.isBefore(dbDate)) {
      return null;
    }
    if (!srDate.isBefore(dbDate)) {
      return startRecurrence;
    }
    DateTime? ret;

    switch (_interval) {
      case 'd':
        ret = startRecurrence.add(Duration(
            days: upperMultiple(dbDate.difference(srDate).inDays, count)));
        break;
      case 'w':
        var weeks = (dbDate.difference(srDate).inDays ~/ (7 * count));
        ret = startRecurrence.add(Duration(days: (weeks * count * 7)));
        while (ret!.isBefore(dbDate)) {
          ret = stepForced(ret);
        }
        break;
      case 'm':
        var steps =
            ((dbDate.year - srDate.year) * 12 + dbDate.month - srDate.month) ~/
                _count;
        if (_monthDay! > 28) {
          ret = DateTime(srDate.year, srDate.month + steps * _count + 1, 0,
              startRecurrence.hour, startRecurrence.minute);
          if (ret.day > _monthDay!) {
            ret = ret.subtract(Duration(days: ret.day - _monthDay!));
          }
        } else if (_monthDay! > 0) {
          ret = DateTime(
            srDate.year,
            srDate.month + steps * _count,
            srDate.day,
            startRecurrence.hour,
            startRecurrence.minute,
          );
        } else {
          ret = DateTime(
            srDate.year,
            srDate.month + steps * _count + 1,
            _monthDay!,
            startRecurrence.hour,
            startRecurrence.minute,
          );
        }
        if (ret.isBefore(dbDate)) {
          ret = stepForced(ret);
        }
        break;
      case 'n':
        var steps =
            ((dbDate.year - srDate.year) * 12 + dbDate.month - srDate.month) ~/
                _count;
        ret = stepForced(startRecurrence, n: steps);
        if (ret.isBefore(dbDate)) {
          ret = stepForced(ret);
        }
        break;
      case 'y':
        var ydiff = (dbDate.year - srDate.year) ~/ _count;
        ret = DateTime(srDate.year + ydiff * _count, srDate.month, srDate.day,
            startRecurrence.hour, startRecurrence.minute);
        if (ret.isBefore(dbDate)) {
          ret = stepForced(ret);
        }
        break;
      default:
        return null;
    }
    if (!_lastStart.isBefore(ret)) {
      return ret;
    }
    return null;
  }

  RecurrencePattern copyWith({
    String? interval,
    int? count,
    DateTime? lastOccurrence,
    List<int>? weekDays,
    int? monthDay,
    int? weekDay,
    int? weekNumber,
  }) {
    return RecurrencePattern(
      interval: interval ?? _interval,
      count: count ?? _count,
      lastStart: lastOccurrence ?? _lastStart,
      weekDays: weekDays ?? _weekDays,
      monthDay: monthDay ?? _monthDay,
      weekDay: weekDay ?? _weekDay,
      weekNumber: weekNumber ?? _weekNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecurrencePattern &&
        other._interval == _interval &&
        other._count == _count &&
        other._lastStart == _lastStart &&
        listEquals(other._weekDays, _weekDays) &&
        other._monthDay == _monthDay &&
        other._weekDay == _weekDay &&
        other._weekNumber == _weekNumber;
  }

  @override
  int get hashCode {
    return _interval.hashCode ^
        _count.hashCode ^
        _lastStart.hashCode ^
        _weekDays.hashCode ^
        _monthDay.hashCode ^
        _weekDay.hashCode ^
        _weekNumber.hashCode;
  }
}

class MonthDirectionChoice {
  String interval;
  bool forward;
  MonthDirectionChoice({
    required this.interval,
    required this.forward,
  }) : assert(
            interval == RecurrencePattern.m || interval == RecurrencePattern.n);
  MonthDirectionChoice.forward()
      : interval = RecurrencePattern.n,
        forward = true;
  MonthDirectionChoice.backward()
      : interval = RecurrencePattern.n,
        forward = false;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MonthDirectionChoice &&
        other.interval == interval &&
        other.forward == forward;
  }

  @override
  int get hashCode => interval.hashCode ^ forward.hashCode;
}
