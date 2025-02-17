
import '../column/fields.dart';
import '../column_type/enum.dart';
import '../model.dart';

class DatabaseTableTable extends IDatabaseTable {
  static String get tableName => "tables";
  static String get colName => "name";
  static String get colDateCreated => "dateCreated";
  static DatabaseTableTable instance = DatabaseTableTable._();
  factory DatabaseTableTable() => instance;
  DatabaseTableTable._()
      : super(tableName, [
          DatabaseColumnFields(name: colName, type: DatabaseColumnType.str),
          DatabaseColumnFields(
              name: colDateCreated, type: DatabaseColumnType.dt),
        ]);
}
