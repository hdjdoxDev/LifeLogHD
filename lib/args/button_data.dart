import 'package:flutter/material.dart';

class ButtonData {
  final IconData? icon;
  final String? emoji;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const ButtonData({
    this.icon,
    this.emoji,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });
}
