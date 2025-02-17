enum Dig {
  vase,
  root,
  plant,
  log;

  String get emoji => switch (this) {
        Dig.vase => "🏺",
        Dig.root => "🫚",
        Dig.plant => "🪴",
        Dig.log => "🪵"
      };
}
