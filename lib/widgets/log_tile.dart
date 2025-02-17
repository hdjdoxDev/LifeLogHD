import 'package:flutter/cupertino.dart';

import '../args/button_data.dart';
import '../utils/constants/spacing.dart';
import '../enums/dye.dart';
import '../data/log.dart';
import 'trailing_log_button.dart';

class LogTile extends StatelessWidget {
  final LogEntry entry;
  final void Function(LogEntry) entryAction;
  final void Function(LogEntry) copyEntry;
  final void Function(LogEntry) selectLog;
  final bool selected;

  const LogTile({
    required this.entry,
    required this.copyEntry,
    required this.entryAction,
    required this.selectLog,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => copyEntry(entry),
      onLongPress: () => selectLog(entry),
      child: Padding(
        padding:
            const EdgeInsets.only(left: dp, right: up, bottom: dhp, top: dhp),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((tp + hp)),
            color: noneColor,
          ),
          padding: const EdgeInsets.all(dhp + hp),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: tp,
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: entry.dye.color, width: textHeight),
                        left: BorderSide(color: entry.dye.color, width: dhp),
                        bottom: BorderSide(color: entry.dye.color, width: dhp),
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(tp),
                          bottomLeft: Radius.circular(tp))),
                ),
                const SizedBox(width: dhp),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.readableTime,
                          style: TextStyle(
                            fontSize: smallFontSize,
                            color: entry.dye.color,
                          )),
                      Text(entry.msg,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: normalFontSize,
                              color:
                                  !selected ? Dye.all.color : Dye.none.color)),
                    ],
                  ),
                ),
                const SizedBox(width: up),
                TrailingLogButton(
                  color: entry.dye.color,
                  buttonData: ButtonData(
                    emoji: "📦",
                    onLongPress: () => {},
                    onTap: () => entryAction(entry),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
