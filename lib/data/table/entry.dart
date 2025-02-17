
import '../entry/model.dart';
import '../model.dart';
import 'fields.dart';

class DatabaseTableEntry extends DatabaseTableFields implements IFields {
  final int id;

  DatabaseTableEntry({
    required this.id,
    required String name,
    required DateTime created,
  }) : super(name: name, created: created);

  // DatabaseTableEntry.fromTable(Map<String, dynamic> map)
  //     : id = map[IDatabaseTable.colId],
  //       super.fromTable(map);

  @override
  Map<String, Object?> toTable() => {
        IDatabaseTable.colId: id,
        ...super.toTable(),
      };
}