import 'package:flutter/material.dart';

const Color noneColor = Color.fromARGB(255, 0, 0, 0);
const Color allColor = Color.fromARGB(255, 255, 255, 255);

enum Dye {
  all,
  yellow,
  red,
  green,
  blue,
  purple,
  orange,
  none;

  static List<Dye> get coloredValues => [
        red,
        orange,
        yellow,
        green,
        blue,
        purple,
      ];

  static List<Dye> get orderedValues => [
        red,
        orange,
        yellow,
        all,
        green,
        blue,
        purple,
      ];

  Color get color => switch (this) {
        Dye.yellow => const Color.fromARGB(255, 255, 199, 1),
        Dye.red => const Color.fromARGB(255, 246, 39, 0),
        Dye.green => const Color.fromARGB(255, 77, 175, 79),
        Dye.blue => const Color.fromARGB(255, 2, 106, 232),
        Dye.purple => const Color.fromARGB(255, 133, 22, 180),
        Dye.orange => const Color.fromARGB(255, 255, 121, 0),
        Dye.all => const Color.fromARGB(255, 255, 255, 255),
        Dye.none => const Color.fromARGB(255, 14, 14, 14)
      };

  String get short => switch (this) {
        Dye.yellow => 'y',
        Dye.red => 'r',
        Dye.green => 'g',
        Dye.blue => 'b',
        Dye.purple => 'p',
        Dye.orange => 'o',
        Dye.all => 'w',
        Dye.none => 'n'
      };

  bool isIn(Dye d) => d == Dye.all || this == d;

  String get defaultName => switch (this) {
        Dye.yellow => "own",
        Dye.red => "play",
        Dye.green => "be",
        Dye.blue => "do",
        Dye.purple => "feel",
        Dye.orange => "earn",
        Dye.none => "none",
        Dye.all => "life"
      };
}
