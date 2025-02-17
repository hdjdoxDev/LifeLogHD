import 'package:flutter/material.dart';

import '../utils/constants/spacing.dart';
import '../enums/dye.dart';
import '../utils/stringify.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    super.key,
    required this.title,
    required this.emoji,
    required this.color,
    required this.dt,
  });

  final String title;
  final String emoji;
  final Color color;
  final DateTime dt;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        height: kToolbarHeight,
        padding: const EdgeInsets.symmetric(horizontal: up),
        decoration: BoxDecoration(
          color: noneColor,
          borderRadius: BorderRadius.circular(up),
        ),
        duration: const Duration(milliseconds: millDuration),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: hp),
                  Text(emoji,
                      style: TextStyle(
                          color: Dye.all.color,
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w200)),
                  const Spacer(),
                  Text(title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        color: color,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
            ),
            Text("Log",
                style: TextStyle(
                    color: Dye.all.color,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w200)),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(timeEmojis[dt.hour % 12],
                      style: TextStyle(
                          color: Dye.all.color, fontSize: titleFontSize)),
                  const SizedBox(width: up),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekDaysShort(dt.weekday),
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Dye.all.color,
                        ),
                      ),
                      Container(
                        height: hp,
                        width: 30,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(dhp),
                        ),
                        margin: const EdgeInsets.only(top: 2.0),
                      ),
                      Text(
                        "${dt.day < 10 ? '0' : ''}${dt.day}",
                        style: TextStyle(
                          fontSize: normalFontSize,
                          color: Dye.all.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const timeEmojis = [
    "🕛",
    "🕐",
    "🕑",
    "🕒",
    "🕓",
    "🕔",
    "🕕",
    "🕖",
    "🕗",
    "🕘",
    "🕙",
    "🕚"
  ];
}
