
import '../../utils/time.dart';

import '../column_type/enum.dart';
import '../entry/model.dart';
import 'fields.dart';
import 'table.dart';

class DatabaseColumnEntry extends DatabaseColumnFields implements IEntry {
  @override
  final int id;
  @override
  String get table => super.table!;
  @override
  String get name => super.name!;
  @override
  DatabaseColumnType get type => super.type!;
  @override
  String get def => super.def!;
  @override
  bool get key => super.key!;
  @override
  bool get unique => super.unique!;

  DatabaseColumnEntry({
    required this.id,
    required super.name,
    required super.type,
    required super.table,
    super.key = false,
    super.unique = false,
    super.def = "",
  });

  @override
  int? get exportId => 0;

  @override
  int get lastModified => now.millisecondsSinceEpoch;

  DatabaseColumnEntry.fromTable(super.map)
      : id = map[DatabaseColumnTable.colId], super.fromTable();

  @override
  DatabaseColumnFields get fields => this;

  @override
  String get entryNotes => "";
}
