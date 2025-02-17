import 'model.dart';
import '../utils/stringify.dart';
import '../utils/time.dart';

import '../enums/due.dart';
import 'fields.dart';

const String commaSeparator = ";";

class LogEntry extends LogFields {
  final int id;
  int lastModified;

  LogFields get fields => this;

  bool get living => due == Due.record;
  bool get caring => due == Due.before;
  bool get hoping => due == Due.after;

  LogEntry.fromFields(LogFields sf, this.id, this.lastModified)
      : super(sf.msg, dye: sf.dye, dateCreated: sf.dateCreated);

  // ignore: use_super_parameters
  LogEntry.fromTable(Map<String, dynamic> map)
      : id = map[IDatabaseTable.colId],
        lastModified = map[IDatabaseTable.colLastModified],
        super.fromTable(map);

  DateTime get time => dateCreated ?? DateTime(2015, 23, 12);

  String get readableTime =>
      "${dateTimeString(time)} - ${weekDaysShort(time.weekday)}";

  String get searchable => "$msg$readableTime";

  @override
  Map<String, Object?> toTable() => {
        IDatabaseTable.colId: id,
        IDatabaseTable.colLastModified: lastModified,
        ...super.toTable(),
      };

  @override
  LogEntry update(dynamic fields) {
    super.update(fields);
    return this;
  }

  static String csvHeaderContent({String commaSeparator = commaSeparator}) =>
      ["msg", "dateCreated", "dye", "due"].join(commaSeparator);

  String toCsvContent({String commaSeparator = commaSeparator}) => [
        msg,
        dateCreated,
        dye.index,
        dye.index,
      ].join(commaSeparator);
}
