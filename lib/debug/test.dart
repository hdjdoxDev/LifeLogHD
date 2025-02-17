import '../data/fields.dart';
import '../enums/dye.dart';
import '../data/log.dart';

var testLog = LogEntry.fromFields(
  LogFields("here will go the server sync feature",
      dye: Dye.blue, dateCreated: DateTime(0, 0, -1, 0)),
  0,
  0,
);
