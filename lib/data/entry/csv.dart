// ignore_for_file: prefer_final_fields

import '../entry/model.dart';
import '../model.dart';
import '../../utils/time.dart';

abstract class ICsvEntry extends ICsvFields {
  String id = "0";
  String entryNotes = "";
  int lastModified;
  int? exportId;

  ICsvEntry.fromStringMap(super.map)
      : id = map[IDatabaseTable.colId] != null &&
                map[IDatabaseTable.colId]!.isNotEmpty
            ? map[IDatabaseTable.colId]!
            : "0",
        entryNotes = map[IDatabaseTable.colEntryNotes] ?? "",
        lastModified = map[IDatabaseTable.colLastModified] != null &&
                map[IDatabaseTable.colLastModified]!.isNotEmpty
            ? int.parse(map[IDatabaseTable.colLastModified]!)
            : now.millisecondsSinceEpoch,
        exportId = int.tryParse(map[IDatabaseTable.colExportId] ?? ""),
        super.fromStringMap();

  ICsvEntry.fromCsv(super.row)
      : id = "0",
        entryNotes = "",
        lastModified = 0,
        exportId = null,
        super.fromCsv();

  static List<String> get csvHeaders => [
        IDatabaseTable.colId,
        ...ICsvFields.csvHeaders,
        IDatabaseTable.colEntryNotes,
        IDatabaseTable.colLastModified,
        IDatabaseTable.colExportId,
      ];

  @override
  List<String> toStringList() => [
        id.toString(),
        ...super.toStringList(),
        entryNotes,
        exportId.toString(),
        lastModified.toString(),
      ];

  @override
  String toCsv() => toStringList().join(';');

  void touch() {
    lastModified = now.millisecondsSinceEpoch;
  }

  void setExportId(int? exportId) {
    exportId = exportId;
  }

  void setEntryNotes(String? entryNotes) {
    entryNotes = entryNotes ?? "";
  }
}

abstract class ICsvFields extends IFields {
  static List<String> get csvHeaders => [];
  ICsvFields.fromStringMap(Map<String, String> map);
  ICsvFields.fromCsv(String row);
  List<String> toStringList() => [];
  String toCsv() => toStringList().join(';');
}
