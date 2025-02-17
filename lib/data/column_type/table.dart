import '../column/fields.dart';
import '../model.dart';

import 'enum.dart';

class DatabaseColumnTypeTable extends IDatabaseTable {
  static final DatabaseColumnTypeTable _instance = DatabaseColumnTypeTable._();
  factory DatabaseColumnTypeTable() => _instance;

  static String get tableName => 'databaseColumnType';
  static String get colId => 'id';
  static String get colName => 'name';
  static String get colNice => 'nice';
  static String get colSqflite => 'sqflite';

  DatabaseColumnTypeTable._()
      : super(tableName, [
          DatabaseColumnFields(
              name: colId, type: DatabaseColumnType.int, key: true),
          DatabaseColumnFields(name: colName, type: DatabaseColumnType.str),
          DatabaseColumnFields(name: colNice, type: DatabaseColumnType.str),
          DatabaseColumnFields(name: colSqflite, type: DatabaseColumnType.str),
        ]);
}
