
import '../enums/due.dart';
import '../enums/dye.dart';
import 'log_table.dart';

class LogFields {
  String msg = "";
  Dye dye = Dye.all;
  DateTime? dateCreated;
  Due? due;

  LogFields(this.msg,
      {this.dye = Dye.all, this.dateCreated, this.due});

  Map<String, Object?> toTable() => {
        LogTable.colMsg: msg,
        LogTable.colDye: dye.short,
        if (dateCreated != null)
          LogTable.colDateCreated: dateCreated!.millisecondsSinceEpoch,
        LogTable.colDue: due?.index,
      };

  //from table
  @override
  LogFields.fromTable(Map<String, dynamic> map)
      : msg = map[LogTable.colMsg],
        dye = Dye.values.firstWhere((e) => e.short == map[LogTable.colDye],
            orElse: () => Dye.all),
        dateCreated = DateTime.fromMillisecondsSinceEpoch(
            map[LogTable.colDateCreated] ?? 0),
        due = Due.values[map[LogTable.colDue] ?? 1];

  LogFields update(fields) {
    if (fields is LogFields) {
      msg = fields.msg;
      dye = fields.dye;
      dateCreated = fields.dateCreated;
    }
    return this;
  }
}
