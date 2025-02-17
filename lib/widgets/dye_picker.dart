import 'package:flutter/material.dart';

import '../providers/dim.dart';
import '../utils/constants/spacing.dart';

class DyePicker extends StatelessWidget {
  const DyePicker({
    required this.dim,
    super.key,
    this.onDrag,
  });
  final void Function(DragUpdateDetails, BuildContext)? onDrag;
  final Dim dim;

  @override
  Widget build(BuildContext context) {
    const double heightButtons = tp;
    const double radius = up;
    return GestureDetector(
      onHorizontalDragUpdate: onDrag != null
          ? (details) => onDrag!(details, context)
          : (details) => {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: millDuration),
        color: dim.activeColor,
        height: radius * 3.5,
        padding: const EdgeInsets.all(hp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var dye in dim.dyes)
              Expanded(
                child: InkWell(
                  onTap: () => dim.setDye(dye),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: dhp),
                    decoration: BoxDecoration(
                      color:
                          dye.isIn(dim.activeDye) ? dim.activeColor : dye.color,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    height: heightButtons,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
