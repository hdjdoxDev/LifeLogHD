// ignore_for_file: prefer_final_fields

import 'model.dart';
import '../model.dart';

abstract class ISqflFields implements IFields {
  ISqflFields.fromTable(Map<String, dynamic> map);
  Map<String, Object?> toTable() => {};
}

abstract class ISqflEntry extends ISqflFields implements IEntry {
  @override
  final int id;
  @override
  String entryNotes = "";
  @override
  int lastModified;
  @override
  int? exportId;

  ISqflEntry.fromTable(super.map)
      : id = map[IDatabaseTable.colId],
        entryNotes = map[IDatabaseTable.colEntryNotes],
        lastModified = map[IDatabaseTable.colLastModified],
        exportId = map[IDatabaseTable.colExportId],
        super.fromTable();

  @override
  Map<String, Object?> toTable() => {
        IDatabaseTable.colId: id,
        ...super.toTable(),
        IDatabaseTable.colEntryNotes: entryNotes,
        IDatabaseTable.colLastModified: lastModified,
        IDatabaseTable.colExportId: exportId,
      };
}
