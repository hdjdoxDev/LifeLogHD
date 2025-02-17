
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

import '../utils/constants/spacing.dart';

class VideoContainer extends StatelessWidget {
  const VideoContainer(
    this.controller, {
    super.key,
  });

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(hp),
        child: AspectRatio(
          aspectRatio: 2.4380952092527433,
          child: ClipRRect(
            borderRadius: BorderRadius.circular((tp + hp)),
            child: VideoPlayer(controller),
          ),
        ),
      ),
    );
  }
}
