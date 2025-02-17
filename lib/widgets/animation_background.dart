import 'package:flutter/widgets.dart';

import '../utils/constants/spacing.dart';
import '../enums/dye.dart';

class AnimationBackground extends StatelessWidget {
  const AnimationBackground({
    required this.snapshot,
    required this.color,
    super.key,
  });
  final AsyncSnapshot<(int, int, int)> snapshot;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return snapshot.connectionState == ConnectionState.active &&
            snapshot.hasData
        ? Row(
            children: [
              Expanded(
                flex: snapshot.data!.$1,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(up)),
                  duration: const Duration(milliseconds: millDuration),
                ),
              ),
              Expanded(
                flex: snapshot.data!.$2,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: noneColor,
                      borderRadius: BorderRadius.circular(up)),
                  duration: const Duration(milliseconds: millDuration),
                ),
              ),
              Expanded(
                flex: snapshot.data!.$3,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(up)),
                  duration: const Duration(milliseconds: millDuration),
                ),
              ),
            ],
          )
        : AnimatedContainer(
            decoration: BoxDecoration(
                color: noneColor, borderRadius: BorderRadius.circular(up)),
            duration: const Duration(milliseconds: millDuration),
          );
  }
}
