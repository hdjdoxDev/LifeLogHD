
import '../model.dart';

import '../column_type/enum.dart';
import 'fields.dart';

class DatabaseColumnTable extends IDatabaseTable {
  static final DatabaseColumnTable _instance = DatabaseColumnTable._();
  factory DatabaseColumnTable() => _instance;

  static String get tableName => 'databaseColumn';
  static String get colId => 'id';
  static String get colName => 'name';
  static String get colType => 'type';
  static String get colKey => 'key';
  static String get colUnique => 'unique';
  static String get colReference => 'reference';
  static String get colTable => 'table';
  static String get colDef => 'def';

  DatabaseColumnTable._()
      : super(tableName, [
          DatabaseColumnFields(
              name: colId, type: DatabaseColumnType.int, key: true),
          DatabaseColumnFields(name: colName, type: DatabaseColumnType.str),
          DatabaseColumnFields(name: colType, type: DatabaseColumnType.en),
          DatabaseColumnFields(name: colKey, type: DatabaseColumnType.bool),
          DatabaseColumnFields(name: colUnique, type: DatabaseColumnType.bool),
          DatabaseColumnFields(
              name: colReference, type: DatabaseColumnType.str),
          DatabaseColumnFields(name: colTable, type: DatabaseColumnType.en),
          DatabaseColumnFields(name: colDef, type: DatabaseColumnType.str),
        ]);
}
