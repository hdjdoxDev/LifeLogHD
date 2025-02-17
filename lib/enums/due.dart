enum Due {
  before,
  record,
  after;

  get emoji => switch (this) {
        Due.before => "⏪️",
        Due.record => "⏺️",
        Due.after => "⏩️"
      };
}
