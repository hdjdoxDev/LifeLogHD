import 'package:flutter/material.dart';
import 'package:lifeloghd/utils/constants/preferences.dart';
import 'providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'data/log_api.dart';
import 'args/button_data.dart';
import 'utils/constants/spacing.dart';
import 'data/log.dart';
import 'enums/dig.dart';
import 'locator.dart';
import 'providers/dim.dart';
import 'providers/animation.dart';
import 'widgets/animation_background.dart';
import 'widgets/bottom_text_field.dart';
import 'widgets/dye_picker.dart';
import 'widgets/hidden_buttons.dart';
import 'widgets/log_tile.dart';
import 'widgets/log_tiles.dart';
import 'widgets/reactive_appbar.dart';
import 'widgets/video_controller.dart';
import 'utils/time.dart';

class LifeLogView extends StatefulWidget {
  const LifeLogView({super.key});

  @override
  State<LifeLogView> createState() => _LifeLogViewState();
}

class _LifeLogViewState extends State<LifeLogView> {
  DateTime access = now;

  final ItemScrollController itemScrollController = ItemScrollController();

  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Consumer<Dim>(
      builder: (context, dim, child) => Scaffold(
        body: Column(
          children: [
            Consumer<SettingsProvider>(
              builder: (context, settings, child) => ReactiveAppBar(
                dim: dim,
                dt: now,
                title: settings.getTitle(),
                leadingData: ButtonData(
                    onTap: () => context.read<AnimationLogic>().setTimer(
                        int.tryParse(settings.getString(pkLongTimer)) ?? 7),
                    onLongPress: () =>
                        context.read<AnimationLogic>().stopTimer(),
                    emoji: dim.longCare),
                trailingData: ButtonData(
                    onTap: () => context.read<AnimationLogic>().setTimer(
                        int.tryParse(settings.getString(pkLongTimer)) ?? 3),
                    onLongPress: () =>
                        context.read<AnimationLogic>().stopTimer(),
                    emoji: dim.shortCare),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: millDuration),
                color: dim.activeColor,
                padding: const EdgeInsets.all(hp),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: dim.pageCtrl,
                  children: [
                    Consumer<SettingsProvider>(
                      builder: (context, settings, child) =>
                          SingleChildScrollView(
                        child: Column(
                          children: settings
                              .keys(dim.activeDye)
                              .map((e) => LogTile(
                                    entry: e,
                                    entryAction: (e) {},
                                    copyEntry: (e) {},
                                    selectLog: (e) {
                                      settings.selectKey(e.id);
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    Consumer<AnimationLogic>(
                      builder: (context, animation, child) => GestureDetector(
                        onTap: () => animation.togglePause(),
                        onLongPressStart: (_) => animation.startCharge(),
                        onLongPressEnd: (_) => animation.stopCharge(),
                        child: Stack(
                          children: [
                            // background
                            StreamBuilder(
                                stream: animation.chargeStream,
                                builder: (context, snapshot) =>
                                    AnimationBackground(
                                        snapshot: snapshot,
                                        color: dim.activeColor)),
                            VideoContainer(animation.activeController),
                            HiddenButtons(
                              onTap: (i) {
                                dim.letterTap(i);
                                animation.togglePause();
                              },
                              onLongPressStart: (_) => animation.startCharge(),
                              onLongPressEnd: (_) => animation.stopCharge(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: locator<LogApi>().resultsLogOut(dim, access),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                                  ConnectionState.active ||
                              !snapshot.hasData) {
                            return Container();
                          }
                          List<LogEntry> results = snapshot.data!;
                          List<GlobalKey> keys =
                              results.map((e) => GlobalKey()).toList();
                          return LogTiles(
                            color: dim.activeColor,
                            itemScrollController: itemScrollController,
                            itemPositionsListener: itemPositionsListener,
                            results: results,
                            keys: keys,
                            copyLog: dim.copyLog,
                          );
                        }),
                  ],
                ),
              ),
            ),
            DyePicker(
              dim: dim,
              onDrag: (du, context) => {},
            ),
            BottomTextInput(
              activeColor: dim.activeColor,
              leadingData: ButtonData(
                  onTap: dim.changePage,
                  onLongPress: dim.deepPage,
                  emoji: dim.nextDig.emoji),
              trailingData: ButtonData(
                  onTap: () {
                    if (dim.activeDig == Dig.log) {
                      context.read<SettingsProvider>().saveLog();
                    } else {
                      locator<LogApi>().saveLog(dim);
                    }
                  },
                  onLongPress: dim.clearInput,
                  emoji: dim.saveEmoji),
              controller: dim.textController,
              focusNode: dim.focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
