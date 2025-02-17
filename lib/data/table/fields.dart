
import 'table.dart';
import '../entry/model.dart';
import '../../utils/time.dart';

class DatabaseTableFields implements IFields {
  String? name;
  DateTime? created;

  DatabaseTableFields({
    required this.name,
    this.created,
  });

  // @override
  Map<String, Object?> toTable() {
    return {
      DatabaseTableTable.colName: name,
      DatabaseTableTable.colDateCreated: created?.millisecondsSinceEpoch ?? now,
    };
  }

  // DatabaseTableFields.fromTable(Map<String, dynamic> map)
  //     : name = map[DatabaseTableTable.colName],
  //       created = DateTime.fromMillisecondsSinceEpoch(
  //           map[DatabaseTableTable.colDateCreated]);

  @override
  DatabaseTableFields update(fields) {
    if (fields is DatabaseTableFields) {
      name = fields.name;
      created = fields.created;
    }
    return this;
  }
}
