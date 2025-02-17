import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:video_player/video_player.dart';

import 'dim.dart';
import '../enums/dye.dart';

class AnimationLogic extends ChangeNotifier {
  late final Dim dim;
  Map<Dye, VideoPlayerController> videoControllers = {};
  late VideoPlayerController activeController;
  Duration period = const Duration(milliseconds: 200);
  late final StreamSubscription streamSub;
  bool get allAround => dim.activeDye == Dye.all;
  bool get noneAround => dim.activeDye == Dye.none;
  Dye lastColor = Dye.orange;
  int counter = 0;

  Future init(d) async {
    dim = d;
    var stream = Stream.periodic(period);
    await initVideoControllers();
    streamSub = stream.listen((event) {
      if (allAround) {
        changeActiveColor();
      }
      if (noneAround) {
        setLife();
      }
    });
    dim.addListener(() {
      activeController = videoControllers[dim.activeDye]!;
      notifyListeners();
    });
    return this;
  }

  bool get isPlaying => activeController.value.isPlaying;

  changeActiveColor() {
    if (!isPlaying && activeController != videoControllers[Dye.none]) return;
    counter++;
    if (counter % 6 == 0) {
      activeController = Random().nextInt(100) == 23
          ? videoControllers[Dye.none]!
          : videoControllers[Dye.all]!;
      notifyListeners();
      counter = 0;
    } else if (counter == 1) {
      var select = Dye.coloredValues[
          (Dye.coloredValues.indexOf(lastColor) + 1) %
              Dye.coloredValues.length];
      activeController = videoControllers[select]!;
      lastColor = select;
      notifyListeners();
    }
  }

  initVideoControllers() async {
    if (!dim.dyes.contains(Dye.none)) {
      var d = Dye.none;
      videoControllers[d] = VideoPlayerController.asset(
          'icons/animation/${d.short}.mp4',
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await videoControllers[d]!.initialize();
      videoControllers[d]!.setLooping(true);
      videoControllers[d]!.play();
    }
    for (var d in dim.dyes) {
      videoControllers[d] = VideoPlayerController.asset(
          'icons/animation/${d.short}.mp4',
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      await videoControllers[d]!.initialize();
      videoControllers[d]!.setLooping(true);
    }
    for (var d in dim.dyes) {
      videoControllers[d]!.seekTo(Duration.zero);
      videoControllers[d]!.play();
    }
    activeController = videoControllers[dim.activeDye]!;
  }

  void select(Dye c) {
    if (dim.dyes.contains(c)) {
      activeController = videoControllers[c]!;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    streamSub.cancel();
    for (var c in dim.dyes) {
      videoControllers[c]!.dispose();
    }
    super.dispose();
  }

  StreamSubscription? streamSubLaunch;

  void launchBlob(double pressTime) {
    var periods = 12;
    var thresholdSpeed = 0.01;
    var periodDuration = const Duration(milliseconds: 100);
    var stream = Stream<num>.periodic(periodDuration, (p) => exp(-p / periods));
    dim.setDye(dim.activeDye == Dye.none ? Dye.none : Dye.all);

    for (var c in dim.dyes) {
      videoControllers[c]!.setPlaybackSpeed(pressTime * 20 + 0.01);
      videoControllers[c]!.play();
    }
    streamSubLaunch?.cancel();
    streamSubLaunch = stream.listen((newSpeed) {
      if (newSpeed < thresholdSpeed) {
        streamSubLaunch!.cancel();
        dim.setDye(videoControllers.entries
            .where((e) => e.value == activeController)
            .first
            .key);
        setPause();
      } else {
        for (var c in dim.dyes) {
          videoControllers[c]!.setPlaybackSpeed(pressTime * 20 * newSpeed);
        }
      }
    });
  }

  setPause() {
    for (var c in dim.dyes) {
      videoControllers[c]!.pause();
      videoControllers[c]!.setPlaybackSpeed(1);
    }
  }

  togglePause() {
    if (noneAround) {
      lifeCounter = 0;
      videoControllers[Dye.none]!.seekTo(const Duration(milliseconds: 20));
      return;
    }
    for (var c in dim.dyes) {
      if (videoControllers[c]!.value.isPlaying) {
        videoControllers[c]!.pause();
      } else {
        videoControllers[c]!.setPlaybackSpeed(1);
        videoControllers[c]!.play();
      }
    }
  }

  void goBack() {
    var total = videoControllers[Dye.all]!.value.duration.inMilliseconds;
    var at = videoControllers[Dye.all]!.value.position.inMilliseconds;
    for (var c in dim.dyes) {
      videoControllers[c]!.seekTo(Duration(milliseconds: (at - 150) % total));
    }
  }

  void setPlay() {
    for (var c in dim.dyes) {
      videoControllers[c]!.play();
      videoControllers[c]!.setPlaybackSpeed(1);
    }
  }

  int lifeCounter = 0;
  double _playbackSpeed = 0;
  set playbackSpeed(double a) {
    for (var v in videoControllers.values) {
      v.setPlaybackSpeed(a);
    }
    _playbackSpeed = a;
  }

  double get playbackSpeed => _playbackSpeed;

  void setLife() {
    lifeCounter += 1;
    var vc = videoControllers[Dye.none]!;
    if (lifeCounter == 1) {
      playbackSpeed = 0.1;
      vc.play();
    }
    if (lifeCounter == 2) {
      vc.pause();
    }
    if (lifeCounter == 3) {
      vc.play();
    }
    if ([5, 10, 20, 15, 25].contains(lifeCounter)) {
      playbackSpeed *= 2;
    }
    if (lifeCounter == 29) {
      playbackSpeed = 1;
      vc.pause();
    }
    if (lifeCounter == 31) {
      vc.seekTo(const Duration(milliseconds: 20));
    }
  }

  Stream? stream;
  StreamSubscription? sub;
  static const int tick = 100;
  double charge = 0.0;

  void startCharge() {
    dim.setDye(Dye.all);
    stream = Stream.periodic(const Duration(milliseconds: tick * 3), (x) => x);
    setPause();
    sub = stream!.listen((x) {
      if (charge < 1) {
        goBack();
        charge += 0.05;
        notifyChargeBar();
      } else {
        setPause();
      }
    });
  }

  void notifyChargeBar() {
    int leftBoxLenght =
        bounded(min((timed * slots) ~/ 1, slots - (charge * slots) ~/ 1));
    int rightBoxLenght =
        bounded(min((charge * slots) ~/ 1, slots - (timed * slots) ~/ 1));
    chargeStreamController.add((
      leftBoxLenght,
      slots - leftBoxLenght - rightBoxLenght,
      rightBoxLenght
    ));
  }

  StreamController<(int, int, int)> chargeStreamController =
      StreamController<(int, int, int)>.broadcast();

  Stream<(int, int, int)> get chargeStream => chargeStreamController.stream;

  int bounded(int value, [int from = 0, int to = slots]) {
    return min(max(value, from), to);
  }

  static const int slots = 128;
  double get timed => min(
      totalMillisenconds == 0 ? 0 : elapsedMilliseconds / (totalMillisenconds),
      1);

  int totalMillisenconds = 0;
  int elapsedMilliseconds = 0;
  StreamSubscription? streamSubTimer;

  void stopCharge() {
    sub!.cancel();
    launchBlob(charge);
    charge = 0;
    notifyChargeBar();
  }

  void setTimer(int minutes) {
    makeSound();
    if (streamSubTimer == null) {
      totalMillisenconds = minutes * 60000;
      var stream =
          Stream.periodic(const Duration(milliseconds: tick), (x) => tick * x);
      streamSubTimer = stream.listen((elapsed) {
        if (elapsed < totalMillisenconds) {
          elapsedMilliseconds = elapsed;
          // print("$leftBoxLenght $rightBoxLenght");
          notifyChargeBar();
        } else {
          stopTimer();
        }
      });
      setPlay();
    } else {
      totalMillisenconds = totalMillisenconds + minutes * 60 * 1000;
      notifyChargeBar();
    }

    setPlay();
  }

  void makeSound() {
    Vibration.hasVibrator().then((value) {
      if (value == true) {
        Vibration.vibrate(duration: 500);
      }
    });
    dim.goToPage(1);
  }

  void stopTimer() {
    streamSubTimer?.cancel();
    streamSubTimer = null;
    setPause();
    makeSound();
    totalMillisenconds = 0;
    elapsedMilliseconds = 0;
    notifyChargeBar();
  }
}
