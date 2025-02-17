import 'package:flutter/material.dart';

import '../args/button_data.dart';
import '../utils/constants/spacing.dart';
import '../enums/dye.dart';

class TrailingLogButton extends StatelessWidget {
  const TrailingLogButton({
    super.key,
    required this.buttonData,
    required this.color,
  });
  VoidCallback? get onTap => buttonData.onTap;
  VoidCallback? get onDoubleTap => buttonData.onDoubleTap;
  VoidCallback? get onLongPress => buttonData.onLongPress;
  final Color color;
  get icon => buttonData.icon;
  final ButtonData buttonData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: bs,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tp),
          color: Dye.none.color,
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: icon != null
              ? Icon(icon, color: color)
              : Text(
                  buttonData.emoji ?? "⚫️",
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
