import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/stringify.dart';

import '../utils/constants/preferences.dart';
import '../data/fields.dart';
import '../data/log.dart';
import '../enums/dig.dart';
import '../enums/dye.dart';
import 'share_logic.dart';
import 'dim.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final Dim dim;
  SettingsProvider(this.prefs, this.dim);

  String dyeKey(Dye d) => "${d.short}$pkDyeNames";

  List<String> get editableKeys => [
        dim.activeDye.short + pkDyeNames,
        pkUserId,
        pkDeviceId,
        pkLongTimer,
        pkShortTimer,
        pkIpAddress,
        pkConnection,
        pkLastExport,
        // pkPassword,
      ];

  List<LogEntry> keys(Dye activeDye) {
    List<LogEntry> ret = [];
    for (int i = 0; i < editableKeys.length; i++) {
      var key = editableKeys[i];
      ret.add(LogEntry.fromFields(
          LogFields("$key=${getString(key)}",
              dye: activeKeyIndex == i ? Dye.all : Dye.none,
              dateCreated: DateTime(2025, 2, 1, 0)),
          i,
          0));
    }
    return ret;
  }

  String getString(String key) => key == pkPassword
      ? "*******"
      : prefs.containsKey(key)
          ? prefs.getString(key)!
          : "";

  String dyeName(Dye d) => capitalize(prefs.containsKey("${d.short}$pkDyeNames")
      ? capitalize(getString("${d.short}$pkDyeNames"))
      : d.defaultName);

  int? activeKeyIndex;

  void selectKey(int id) {
    if (activeKeyIndex == id) {
      activeKeyIndex = null;
      dim.textController.text = "";
    } else {
      activeKeyIndex = id;
      var oldVal = getString(editableKeys[activeKeyIndex!]);
      dim.textController.text = oldVal == "" ? dim.cleanTextInput : oldVal;
    }
    notifyListeners();
  }

  void saveLog() async {
    if (activeKeyIndex != null &&
        activeKeyIndex! < editableKeys.length &&
        activeKeyIndex! >= 0) {
      var activeKey = editableKeys[activeKeyIndex!];
      if (activeKey == pkLongTimer || activeKey == pkShortTimer) {
        if (int.tryParse(dim.cleanTextInput) != null) {
          prefs.setString(activeKey, dim.cleanTextInput);
        }
      } else if (activeKey.substring(1) == pkDyeNames) {
        if (dim.cleanTextInput.length < 6) {
          prefs.setString(activeKey, dim.cleanTextInput);
        }
      } else if (activeKey == pkPassword) {
        if (prefs.getString(pkPassword) == null) {
          prefs.setString(activeKey, dim.cleanTextInput);
        }
      } else {
        prefs.setString(activeKey, dim.cleanTextInput);
      }
      dim.textController.text = "";
      dim.clearInput();
      activeKeyIndex = null;
      notifyListeners();
    }
    if (getString(pkConnection) == "on") {
      var share = ShareLogic(this);
      await share.dumpEntries();
    }
  }

  Future setConnection(String value) =>
      prefs.setString(pkConnection, value).then((_) => notifyListeners());
  Future setLastExport(DateTime value) => prefs
      .setString(pkLastExport, value.toString().substring(0, 19))
      .then((_) => notifyListeners());

  String getTitle() =>
      dim.activeDig == Dig.log ? "Deep" : dyeName(dim.activeDye);
}
