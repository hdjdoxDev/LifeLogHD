import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/log_tile.dart';
import '../utils/constants/spacing.dart';
import '../data/log.dart';

class LogTiles extends StatelessWidget {
  const LogTiles(
      {super.key,
      required this.itemScrollController,
      required this.itemPositionsListener,
      required this.results,
      required this.keys,
      required this.color,
      required this.copyLog});

  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final List<LogEntry> results;
  final List<GlobalKey<State<StatefulWidget>>> keys;
  final Color color;
  final void Function(LogEntry) copyLog;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      duration: const Duration(milliseconds: millDuration),
      child: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        initialScrollIndex: max(results.length - 1, 0),
        initialAlignment: 0,
        itemCount: results.length,
        itemBuilder: (context, i) => RepaintBoundary(
          key: keys[i],
          child: LogTile(
            entry: results[i],
            copyEntry: copyLog,
            entryAction: (e) async {
              itemScrollController.jumpTo(index: i);
              RenderRepaintBoundary? boundary = keys[i]
                  .currentContext
                  ?.findRenderObject() as RenderRepaintBoundary?;
              final image = await boundary!.toImage(pixelRatio: 1);
              final byteData =
                  await image.toByteData(format: ImageByteFormat.png);
              final value = byteData!.buffer.asUint8List();
              final path = '${Directory.systemTemp.path}/my_life_log.png';
              File(path).writeAsBytesSync(value);
              Share.shareXFiles([XFile(path)]);
            },
            selectLog: (_) {},
            selected: false,
          ),
        ),
      ),
    );
  }
}
