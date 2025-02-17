import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import '../locator.dart';
import '../providers/settings_provider.dart';
import '../utils/constants/preferences.dart';
import '../data/log.dart';
import '../data/log_api.dart';

enum ComState { init, sync, done, dump }

const commaSeparator = ";";
const msgSeparator = "\n";
const pipeSeparator = "|";

class ShareLogic {
  Socket? socket;

  late final LogApi api;

  ComState comState = ComState.init;

  String connection = 'ready';

  static const int port = 4646;

  bool connected = false;

  int totNewEntries = 0;

  String residual = "";
  var device = "0";
  var user = "0";
  // late BuildContext lastContext;

  int get totalEntriesNow => totalEntriesLastSync + gotNewEntries;
  int totalEntriesLastSync = 0;
  int gotNewEntries = 0;
  int sentNewEntries = 0;
  int gotUpdatedEntries = 0;
  int sentUpdatedEntries = 0;
  int get leftUntouched =>
      totalEntriesLastSync - gotUpdatedEntries - sentUpdatedEntries;
  String ipAddress = "";

  SettingsProvider settings;

  ShareLogic(this.settings) {
    api = locator<LogApi>();
    ipAddress = settings.getString(pkIpAddress);
    device = settings.getString(pkDeviceId);
    user = settings.getString(pkUserId);
  }

  Future dumpEntries() async {
    comState = ComState.dump;
    try {
      socket = await Socket.connect(ipAddress, port);
    } on SocketException catch (e) {
      failedConnection(e);
      settings.setConnection("failed");
      return;
    }

    settings.setConnection("alive");

    socket!.encoding = utf8;

    socket!.listen(onData);

    var entries = await api.getLogEntries().then(
          (value) => value.where((e) =>
              DateTime.fromMillisecondsSinceEpoch(e.lastModified).isAfter(
                  DateTime.tryParse(settings.getString(pkLastExport)) ??
                      DateTime(1999))),
        );

    sendMessage("DUMP${device}_$user");
    sendMessage("HEAD${LogEntry.csvHeaderContent()}");
    for (var e in entries) {
      sendMessage(
          "NEWE${e.id}$commaSeparator${e.lastModified}$commaSeparator${e.toCsvContent()}");
    }
    sendMessage("DONE");
    settings.setConnection("done");
    settings.setLastExport(DateTime.now());
  }

  void sendMessage(String msg) {
    socket!.write("$msg$msgSeparator");
  }

  void startSink(context) async {
    // lastContext = context;
    // reset sync
    totalEntriesLastSync = 0;
    gotNewEntries = 0;
    sentNewEntries = 0;
    gotUpdatedEntries = 0;
    sentUpdatedEntries = 0;

    comState = ComState.sync;

    try {
      socket = await Socket.connect(ipAddress, port);
    } on SocketException catch (e) {
      failedConnection(e);
      return;
    }

    socket!.encoding = utf8;

    socket!.listen(onData);

    sendMessage("SYNC");
    sendMessage("HEAD${LogEntry.csvHeaderContent}");
    sendMessage(await getSyncInfo());
    sendMessage("DONE");
  }

  void onData(Uint8List data) async {
    var dataString = utf8.decode(data);
    var lines = dataString.split(msgSeparator);
    lines[0] = residual + lines[0];
    residual = lines.removeLast();
    for (var line in lines) {
      handleMessage(line);
    }
  }

  void handleMessage(String line) {
    if (line.isEmpty) {
      return;
    }
    var comm = line.substring(0, 4);
    var args = line.substring(4);

    switch (comm) {
      case "ASKE":
        if (comState == ComState.sync) {
          sendSync(args);
        }
        break;
      case "UPDT":
        if (comState == ComState.sync) {
          // updateEntry(args);
        }
        break;
      case "NEWE":
        if (comState == ComState.sync) {
          // addEntry(args);
        }
        break;
      case "DONE":
        if (comState == ComState.sync) {
          comState = ComState.done;
        } else if (comState == ComState.done) {
          socket!.close();
          socket = null;
          comState = ComState.init;
        } else if (comState == ComState.dump) {
          socket!.close();
          socket = null;
          comState = ComState.init;
        }
        break;
      case "NEWI":
        if (comState == ComState.sync || comState == ComState.done) {
          // setIdExport(args);
        }
        break;
      default:
        break;
    }
  }

  /// format sent:
  ///  INFO + list of [id,lastModified;id,lastModified]
  Future<String> getSyncInfo() async {
    var entries = await api.getLogEntries();
    var exported = entries;

    // save sync stats
    totalEntriesLastSync = exported.length;

    var exportedString = exported
        .map(
          (e) => "${e.id}$commaSeparator${e.lastModified}",
        )
        .join(pipeSeparator);
    var msg = "INFO$exportedString";
    return msg;
  }

  /// msg = list of id
  Future sendSync(String msg) async {
    var entries = await api.getLogEntries();
    // if updated asked, send updated entries
    if (msg != "") {
      var toSend = msg
          .split(commaSeparator)
          .map(
            (e) => int.parse(e),
          )
          .toList();

      // save sync stats
      sentUpdatedEntries = toSend.length;

      // send UPDT + ExportId,lastModified,content
      for (var i in toSend) {
        var match = entries.where(((element) => element.id == i));
        if (match.isNotEmpty) {
          var e = match.first;
          sendMessage(
              "UPDT${e.id}$commaSeparator${e.lastModified}$commaSeparator${e.toCsvContent}");
        }
      }
    }

    //send NEWE + id,lastModified,content
    var missing = entries;
    totNewEntries = missing.length;
    if (missing.isNotEmpty) {
      for (var e in missing) {
        sendMessage(
            "NEWE${e.id}$commaSeparator${e.lastModified}$commaSeparator${e.toCsvContent}");
      }
    } else {
      closeConnection();
    }

    sendMessage("DONE");
  }

  void failedConnection(SocketException e) {
    // showModalBottomSheet(
    //   context: lastContext,
    //   builder: (context) => Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Center(
    //       child: Text('connection failed at $ipAddress:$port'),
    //       // Text('error: ${e.message}'),
    //     ),
    //   ),
    // );
  }

  void closeConnection() {
    sendMessage("DONE");
    // showModalBottomSheet(
    //   context: lastContext,
    //   builder: (context) => Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: [
    //         Text('at last sync they where $totalEntriesLastSync logs'),
    //         Text('of witch $sentUpdatedEntries were sent updated'),
    //         Text('and $gotUpdatedEntries were received udpated'),
    //         Text('so only $leftUntouched remain the same'),
    //         Text('on top we sent $sentNewEntries new logs'),
    //         Text('and received $gotNewEntries so'),
    //         Text('there are $totalEntriesNow logs now'),
    //       ],
    //     ),
    //   ),
    // );
  }

  /// msg = id,id
  /// add id to entry
  /// if all entries have id, send DONE
  // void setIdExport(String msg) async {
  //   var list = msg.split(commaSeparator);
  //   var id = int.parse(list[0]);
  //   api.addExportId(id, id);

  //   // save sync stats
  //   sentNewEntries += 1;

  //   if (sentNewEntries == totNewEntries) {
  //     closeConnection();
  //   }
  // }

  /// add entry to entries
  // void addEntry(String msg) async {
  //   var list = msg.split(commaSeparator);
  //   await api.addEntryFromServer(
  //       eid: int.parse(list[0]),
  //       lm: int.parse(list[1]),
  //       lf: LogFields(
  //         list[2],
  //         dateCreated: DateTime.parse(list[3]),
  //         dye: Dye.values[int.tryParse(list[4]) ?? 0],
  //       ));

  //   // save sync stats
  //   gotNewEntries += 1;
  // }

  /// update entry in entries
  // Future updateEntry(String msg) async {
  //   var list = msg.split(commaSeparator);
  //   await api.updateEntryFromServer(
  //     eid: int.parse(list[0]),
  //     lm: int.parse(list[1]),
  //     lf: LogFields(
  //       list[2],
  //       dye: Dye.values[int.parse(list[4])],
  //       dateCreated: DateTime.parse(list[3]),
  //     ),
  //   );

  //   // save sync stats
  //   gotUpdatedEntries += 1;
  // }
}
