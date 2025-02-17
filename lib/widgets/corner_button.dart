import 'package:flutter/material.dart';

import '../args/button_data.dart';
import '../utils/constants/spacing.dart';
import '../enums/dye.dart';

class CornerButton extends StatelessWidget {
  final ButtonData? data;
  final Color? color;

  const CornerButton({this.data, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onLongPress: data?.onLongPress,
        onTap: data?.onTap,
        onDoubleTap: data?.onDoubleTap,
        customBorder: const CircleBorder(),
        child: Container(
          height: bs,
          width: bs,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(up), color: noneColor),
          padding: const EdgeInsets.all(up),
          child: data?.icon != null
              ? Icon(data?.icon, color: color ?? allColor)
              : Center(
                  // color: Colors.teal,
                  child: Text(
                    data?.emoji ?? "⚫️",
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }
}
