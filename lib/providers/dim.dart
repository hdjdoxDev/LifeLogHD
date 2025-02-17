import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/fields.dart';
import '../enums/dig.dart';
import '../enums/due.dart';
import '../enums/dye.dart';
import '../data/log.dart';

class Dim extends ChangeNotifier {
  List<Dye> dyes = Dye.orderedValues;
  int _selectedDye = 3;
  Due activeDue = Due.record;
  Dig activeDig = Dig.plant;
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Dye get activeDye => dyes[_selectedDye];
  Color get activeColor => activeDye.color;

  Dim() {
    pageCtrl.addListener(() {
      activeDig = Dig.values[pageCtrl.page?.toInt() ?? 1];
      if (pageCtrl.page == 0) {
        activeDig = Dig.log;
        notifyListeners();
      }
      if (pageCtrl.page == 1) {
        activeDig = Dig.plant;
        notifyListeners();
      }
      if (pageCtrl.page == 2) {
        activeDig = Dig.root;
        notifyListeners();
      }
    });
  }

  void setDye(Dye d) {
    var newDye = dyes.indexOf(d);
    _selectedDye = newDye == -1 ? _selectedDye : newDye;
    notifyListeners();
  }

  final secretSequence = "fiLegoL";
  final clearSequence = "LifeLog";
  int progress = 0;

  PageController pageCtrl = PageController(initialPage: 1);

  Dig get nextDig =>
      pageCtrl.hasClients && pageCtrl.page != 1 ? Dig.plant : Dig.root;

  void changePage() => pageCtrl.page == 1
      ? pageCtrl.nextPage(duration: Durations.medium1, curve: Curves.easeInOut)
      : pageCtrl.animateToPage(1,
          duration: Durations.medium1, curve: Curves.easeInOut);

  letterTap(int pos) {
    if (secretSequence[progress] == clearSequence[pos]) {
      progress++;
      if (progress == secretSequence.length) {
        pageCtrl.animateToPage(0,
            duration: Durations.medium1, curve: Curves.easeInOut);
        progress = 0;
      }
    } else {
      progress = 0;
    }
  }

  String get cleanTextInput => cleanText(textController.text);

  String cleanText(String txt) => txt
      .toLowerCase()
      .replaceAll(";", ",")
      .replaceAll("|", "/")
      .replaceAll("\n", ". ")
      .replaceAll("‘", "'")
      .trim();

  String lastText = "";
  void clearInput() {
    if (textController.text == "") {
      textController.text = lastText;
      Clipboard.setData(ClipboardData(text: textController.text));
    } else {
      lastText = textController.text;
      textController.text = "";
    }
    notifyListeners();
  }

  LogFields get writingLog => LogFields(cleanTextInput,
      dye: activeDye, due: activeDue, dateCreated: DateTime.now());

  get saveEmoji => "📜";
  get longCare => "💦";
  get shortCare => "💧";
  get noneEmoji => "⚫️";

  void copyLog(LogEntry e) => textController
    ..text = e.msg
    ..selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));

  void goToPage(int i) => pageCtrl.animateToPage(i,
      duration: Durations.medium1, curve: Curves.easeInOut);

  void deepPage() => pageCtrl.page == 0
      ? pageCtrl.nextPage(duration: Durations.medium1, curve: Curves.easeInOut)
      : pageCtrl.animateToPage(0,
          duration: Durations.medium1, curve: Curves.easeInOut);

}
