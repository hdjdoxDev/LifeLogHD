import '../data/fields.dart';
import '../data/log.dart';
import '../enums/dye.dart';
import '../widgets/log_tile.dart';

var a = LogTile(
  entry: LogEntry.fromFields(
      LogFields(
          "filegol instructions:\n- start the server\n- input ip address\n- capture this log\n- data is saved\n- nah joking\n- yet to come",
          dye: Dye.all,
          dateCreated: DateTime(2025, 1, 30, 5, 37)),
      0,
      1204980394),
  copyEntry: (_) {},
  entryAction: (_) {},
  selectLog: (_) {},
);
