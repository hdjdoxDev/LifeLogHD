import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';

import 'time.dart';

String ordinalDes(int number) {
  if (!(number >= 1 && number <= 100)) {
    //here you change the range
    throw Exception('Invalid number');
  }

  if (number >= 11 && number <= 13) {
    return 'th';
  }

  switch (number % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String literal(int number) {
  return NumberToWord().convert('en-in', number);
}

String literalOrd(int number) {
  return literal(number) + ordinalDes(number);
}

String ordinal(int number) {
  return number.toString() + ordinalDes(number);
}

String weekDaysLong(int i) =>
    DateFormat.EEEE().format(now.add(Duration(days: i - now.weekday)));
String weekDaysShort(int i) =>
    DateFormat.E().format(now.add(Duration(days: i - now.weekday)));

String capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
