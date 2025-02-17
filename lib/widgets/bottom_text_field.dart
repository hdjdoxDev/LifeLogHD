import 'dart:math';

import 'package:flutter/material.dart';

import 'corner_button.dart';
import '../args/button_data.dart';
import '../utils/constants/spacing.dart';
import '../enums/dye.dart';

class BottomTextInput extends StatelessWidget {
  final Color activeColor;
  final ButtonData? leadingData;
  final ButtonData? trailingData;
  final TextEditingController controller;
  final FocusNode focusNode;

  const BottomTextInput({
    required this.activeColor,
    this.leadingData,
    this.trailingData,
    required this.controller,
    required this.focusNode,
    super.key,
  });

  UnderlineInputBorder get coloredBorder => UnderlineInputBorder(
        borderSide: BorderSide(color: activeColor),
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: activeColor,
      duration: const Duration(milliseconds: millDuration),
      padding: EdgeInsets.only(
          top: hp,
          left: max(MediaQuery.of(context).padding.left, hp),
          right: max(MediaQuery.of(context).padding.right, hp),
          bottom: max(MediaQuery.of(context).padding.bottom, hp)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CornerButton(data: leadingData, color: activeColor),
          const SizedBox(width: hp),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: noneColor,
                borderRadius: BorderRadius.circular(up),
              ),
              padding: const EdgeInsets.all(up),
              child: TextField(
                focusNode: focusNode,
                cursorColor: activeColor,
                decoration: InputDecoration(
                  focusedBorder: coloredBorder,
                  enabledBorder: coloredBorder,
                ),
                maxLines: 5,
                minLines: 1,
                controller: controller,
                style:
                    TextStyle(color: Dye.all.color, fontSize: normalFontSize),
              ),
            ),
          ),
          const SizedBox(width: hp),
          CornerButton(data: trailingData, color: activeColor),
        ],
      ),
    );
  }
}
