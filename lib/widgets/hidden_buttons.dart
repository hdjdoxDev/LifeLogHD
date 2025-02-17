
import 'package:flutter/material.dart';

import '../utils/constants/spacing.dart';

class HiddenButtons extends StatelessWidget {
  const HiddenButtons({
    required this.onTap,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    super.key,
  });
  final void Function(int) onTap;
  final void Function(LongPressStartDetails) onLongPressStart;
  final void Function(LongPressEndDetails) onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(hp),
        child: AspectRatio(
          aspectRatio: 2.4380952092527433,
          child: ClipRRect(
            borderRadius: BorderRadius.circular((tp + hp)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 18),
                ...[
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      flex: 10,
                      child: GestureDetector(
                        onTap: () {
                          onTap(i);
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                ],
                const Spacer(flex: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
