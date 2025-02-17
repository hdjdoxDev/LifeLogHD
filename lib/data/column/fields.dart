
import '../column_type/enum.dart';
import '../entry/model.dart';
import '../model.dart';
import 'table.dart';

class DatabaseColumnFields implements IFields {
  String? name;
  DatabaseColumnType? type;
  String? table;
  bool? key;
  bool? unique;
  String? reference;
  String? def;

  DatabaseColumnFields({
    this.name,
    this.type,
    this.table,
    this.key,
    this.unique,
    this.reference,
    this.def,
  });

  @override
  bool operator ==(covariant DatabaseColumnFields other) {
    if (identical(this, other)) return true;

    return other.name == name && other.table == other.table;
  }

  @override
  int get hashCode {
    return name.hashCode ^ type.hashCode ^ key.hashCode ^ unique.hashCode;
  }

  DatabaseColumnFields.fromTable(Map<String, dynamic> map)
      : name = map[DatabaseColumnTable.colName],
        type = DatabaseColumnType.values.firstWhere(
            (e) => e.toString() == map[DatabaseColumnTable.colType]),
        key = IDatabaseTable.getBool(map[DatabaseColumnTable.colKey]),
        unique = IDatabaseTable.getBool(map[DatabaseColumnTable.colUnique]),
        reference = map[DatabaseColumnTable.colReference],
        table = map[DatabaseColumnTable.colTable],
        def = map[DatabaseColumnTable.colDef];

  // @override
  Map<String, Object?> toTable() {
    return {
      DatabaseColumnTable.colName: name,
      DatabaseColumnTable.colType: type.toString(),
      if (key != null)
        DatabaseColumnTable.colKey: IDatabaseTable.getBoolInt(key ?? false),
      if (unique != null)
        DatabaseColumnTable.colUnique:
            IDatabaseTable.getBoolInt(unique ?? false),
      DatabaseColumnTable.colReference: reference,
      DatabaseColumnTable.colTable: table,
      DatabaseColumnTable.colDef: def,
    };
  }

  @override
  DatabaseColumnFields update(fields) {
    if (fields is DatabaseColumnFields) {
      name = fields.name;
      type = fields.type;
      key = fields.key;
      unique = fields.unique;
      reference = fields.reference;
      table = fields.table;
      def = fields.def;
    }
    return this;
  }

  @override
  String toString() {
    return name ?? '';
  }
  
}
