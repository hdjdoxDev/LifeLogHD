import 'model.dart';
import '../utils/time.dart';
import 'column/fields.dart';
import 'column_type/enum.dart';
import 'fields.dart';

class LogTable extends IDatabaseTable {
  static LogTable instance = LogTable._();

  factory LogTable() => instance;
  static String get tableName => 'logsql';

  static String get colMsg => IDatabaseTable.colEntryNotes;
  static String get colDateCreated => "dateCreated";
  static String get colDye => "dye";
  static String get colDue => "due";

  LogTable._()
      : super(
          tableName,
          [
            DatabaseColumnFields(
                name: colDye, type: DatabaseColumnType.str, unique: false),
            DatabaseColumnFields(
                name: colDateCreated, type: DatabaseColumnType.int),
          ],
          addSuggested: true,
        );

  List<LogFields> get initialMsgs => [
        "Hi! We are log entries :)",
        "Down there you can type more :3",
        "That trash can on our right kills us :(",
        "Long press on it to see the cimitery",
        "To activate search mode you need to find the gray lens",
      ].map((e) => LogFields(e, dateCreated: now)).toList();
}
