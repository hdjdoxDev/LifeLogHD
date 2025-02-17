import 'dart:async';

import '../utils/time.dart';
import 'model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../providers/dim.dart';
import '../enums/due.dart';
import 'fields.dart';
import 'log.dart';
import 'log_table.dart';

class LogApi {
  static LogApi? _instance;

  LogApi._(this._db) {
    notifyLogEntries(null);
  }

  static LogTable table = LogTable();

  static const _dbName = 'log.db';

  final Database _db;
  final StreamController<List<LogEntry>> _logEntriesStreamController =
      StreamController.broadcast();

  static Future<LogApi> init() => _instance != null
      ? Future.value(_instance)
      : getDatabasesPath().then((path) => openDatabase(
            p.join(path, _dbName),
            version: 6,
            onCreate: _onCreate,
            onUpgrade: (db, oldVersion, newVersion) {
              if (oldVersion == 5 && newVersion == 6) {
                db.execute("alter table logsql add column due int default 1");
                db.execute("alter table logsql rename column category to dye");
                // db.query("logsql").then((value) => print(value[0]));
              }
            },
          ).then((db) async {
            // write here if you want to make changes to the database
            return db;
          }).then((value) => LogApi._(value)));

  static Future<void> _onCreate(Database db, int version) async {
    db.execute(table.createSqflite);
    // on first run we can add some instructions as first logs
    // for (var lf in table.initialMsgs) {
    //   _addLogEntry(db, lf);
    // }
  }

  Future<int> flushAllData() => _db.delete(table.name);

  static Future<List<LogEntry>> _getLogEntries(Database db) => db
      .query(table.name, orderBy: IDatabaseTable.colLastModified)
      .then((value) => value.map((e) => LogEntry.fromTable(e)).toList());

  Future<List<LogEntry>> getLogEntries() => _getLogEntries(_db);

  Stream<List<LogEntry>> getLogEntriesStream() {
    getLogEntries().then((value) => _logEntriesStreamController.add(value));
    return _logEntriesStreamController.stream;
  }

  Future<LogEntry> getLogEntry(int id) => _db.query(table.name,
      where: '${IDatabaseTable.colId} = ?',
      whereArgs: [id]).then((value) => LogEntry.fromTable(value.first));
  List<LogEntry> entries = [];

  Future<T> notifyLogEntries<T>(T ret) async {
    await getLogEntries().then((e) => _logEntriesStreamController.add(e));
    return ret;
  }

  static Future<int> _addLogEntry(Database db, LogFields lf) => db.insert(
        table.name,
        {
          ...lf.toTable(),
          IDatabaseTable.colLastModified: DateTime.now().millisecondsSinceEpoch
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future<int> addLogEntry(LogFields lf) =>
      _addLogEntry(_db, lf).then((value) => notifyLogEntries(value));

  Future deleteLogEntry(int id) => _db.delete(table.name,
      where: '${IDatabaseTable.colId} = ?',
      whereArgs: [id]).then((value) => notifyLogEntries(value));

  editLogEntry(int id, LogFields lf) => _db
      .update(
        table.name,
        {
          ...lf.toTable(),
          IDatabaseTable.colLastModified: DateTime.now().millisecondsSinceEpoch,
        },
        where: '${IDatabaseTable.colId} = ?',
        whereArgs: [id],
      )
      .then(((value) => notifyLogEntries(value)));

  addEntryFromServer(
          {required int eid, required int lm, required LogFields lf}) =>
      _db
          .insert(
            table.name,
            {
              ...lf.toTable(),
              IDatabaseTable.colLastModified: lm,
              IDatabaseTable.colExportId: eid,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          )
          .then((value) => notifyLogEntries(value));

  void addExportId(int id, int exportId) => _db.update(
        table.name,
        {IDatabaseTable.colExportId: exportId},
        where: '${IDatabaseTable.colId} = ?',
        whereArgs: [id],
      );

  updateEntryFromServer(
          {required int eid, required int lm, required LogFields lf}) =>
      _db
          .update(
            table.name,
            {
              ...lf.toTable(),
              IDatabaseTable.colLastModified: lm,
            },
            where: '${IDatabaseTable.colExportId} = ?',
            whereArgs: [eid],
          )
          .then((value) => notifyLogEntries(value));

  void deleteAll() {
    _db.delete(table.name).then((value) => notifyLogEntries(value));
  }

  void archive(int id) {
    _db
        .update(
          table.name,
          {
            LogTable.colDue: Due.before.index,
            IDatabaseTable.colLastModified:
                DateTime.now().millisecondsSinceEpoch,
          },
          where: '${IDatabaseTable.colId} = ?',
          whereArgs: [id],
        )
        .then(((value) => notifyLogEntries(value)));
  }

  void saveLog(Dim dim) {
    // hide keyboard if no text
    if (dim.cleanTextInput.isEmpty) {
      dim.focusNode.unfocus();
      return;
    }

    // save new log
    else {
      addLogEntry(dim.writingLog);
      dim.goToPage(2);
    }

    dim.textController.text = "";
  }

  Stream<List<LogEntry>> resultsLogOut(Dim dim, DateTime dt) =>
      getLogEntriesStream().map((e) => e
          .where((e) =>
              e.dye.isIn(dim.activeDye) &&
              e.due == dim.activeDue &&
              e.time.isAfter(dt) &&
              e.time.isAfter(now.subtract(Duration(minutes: 30))))
          .toList());
}
