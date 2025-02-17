import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'title_bar.dart';
import 'corner_button.dart';
import '../providers/dim.dart';
import '../providers/settings_provider.dart';
import '../utils/constants/spacing.dart';
import '../args/button_data.dart';

class ReactiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final DateTime dt;
  final Dim dim;
  Color get color => dim.activeColor;
  final ButtonData? leadingData;
  final ButtonData? trailingData;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const ReactiveAppBar({
    super.key,
    required this.dim,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.dt,
    this.leadingData,
    this.trailingData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        color: dim.activeColor,
        duration: const Duration(milliseconds: millDuration),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + hp,
          bottom: hp,
          left: max(MediaQuery.of(context).padding.left, hp),
          right: max(MediaQuery.of(context).padding.right, hp),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CornerButton(data: leadingData, color: color),
            const SizedBox(width: hp),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) => TitleBar(
                title: settings.getTitle(),
                color: dim.activeColor,
                dt: dt,
                emoji: dim.activeDig.emoji,
              ),
            ),
            const SizedBox(width: hp),
            CornerButton(data: trailingData, color: color)
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + up);
}
