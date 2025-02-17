import 'column/fields.dart';
import 'column_type/enum.dart';

/// Rapresentation fo a database table.
///
/// Keeps the [name] for the table name
/// and [columns] with the info of table fields
///
/// The default constructor automatically adds the
/// [defaultColumns] : `id` and optionally adds the
/// [suggestedColumns]`entryNotes`, `lastModified`, `exportId`
///
/// The static getter [createSqflite] generates
/// sql code to create table in `SQFLite`

abstract class IDatabaseTable {
  final String name;
  final List<DatabaseColumnFields> columns;
  static List<DatabaseColumnFields> defaultColumns = [
    DatabaseColumnFields(name: colId, type: DatabaseColumnType.int, key: true),
  ];
  static List<DatabaseColumnFields> suggestedColumns = [
    DatabaseColumnFields(name: colEntryNotes, type: DatabaseColumnType.str),
    DatabaseColumnFields(name: colLastModified, type: DatabaseColumnType.int),
    DatabaseColumnFields(name: colExportId, type: DatabaseColumnType.int),
  ];

  IDatabaseTable(this.name, List<DatabaseColumnFields> columns,
      {bool addDefault = true, bool addSuggested = false})
      : assert(columns.map(((e) => e.name)).toSet().length == columns.length),
        columns = [
          if (addDefault) ...defaultColumns,
          for (var column in columns)
            if ((!addDefault || !defaultColumns.contains(column)) &&
                (!addSuggested || !suggestedColumns.contains(column)))
              column,
          if (addSuggested) ...suggestedColumns
        ];

  String get createSqflite =>
      // ignore: prefer_interpolation_to_compose_strings
      "CREATE TABLE $name (" +
      columns
          .map((entry) =>
              "`${entry.name!}` ${entry.type!.sqflite}${true == entry.key ? ' PRIMARY KEY' : ''}")
          .join(", ") +
      ");";

  List<String> get csvHeaders => columns.map(((e) => e.name!)).toList();

  static String get colId => 'id';
  static String get colLastModified => 'lastModified';
  static String get colEntryNotes => 'entryNotes';
  static String get colExportId => 'exportId';
  static String get colDevice => 'device';

  static bool getBool(int value) => value == 1;
  static int getBoolInt(bool value) => value ? 1 : 0;

  static DateTime getDateTime(int value) =>
      DateTime.fromMillisecondsSinceEpoch(value);
  static int getDateTimeInt(DateTime value) => value.millisecondsSinceEpoch;
}
