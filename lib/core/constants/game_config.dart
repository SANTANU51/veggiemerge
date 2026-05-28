/// Static configuration for layout, physics, and debug flags.
///
/// All values are compile-time constants so they can be used in
/// `const` contexts. Tune physics values here — no magic numbers in game code.
abstract final class GameConfig {
  // — Container layout ───────────────────────────────────────────────────────

  /// Container width as a fraction of screen width.
  static const double containerWidthRatio = 0.90;

  /// Container height as a fraction of screen height.
  static const double containerHeightRatio = 0.75;

  /// Distance from the container's top edge to the danger line, in logical px.
  /// Vegetables that stay above this Y for [dangerThresholdSeconds] end the game.
  static const double dangerLineOffset = 60.0;

  // — Game rules ─────────────────────────────────────────────────────────────

  /// Seconds a vegetable must remain above the danger line to trigger Game Over.
  static const double dangerThresholdSeconds = 2.0;

  // — Forge2D physics ────────────────────────────────────────────────────────

  /// Downward gravitational acceleration in Forge2D world units per second².
  static const double gravity = 30.0;

  /// Conversion factor: logical pixels per Forge2D metre.
  /// Increase for a "zoomed in" feel; decrease to make bodies feel lighter.
  static const double worldScale = 10.0;

  /// Coefficient of restitution (bounciness). 0 = no bounce, 1 = perfect bounce.
  static const double restitution = 0.35;

  /// Coefficient of friction (rolling resistance). Higher = more drag.
  static const double friction = 0.6;

  /// Density of all vegetable bodies in kg/m².
  static const double density = 1.0;

  // — Debug / development flags ─────────────────────────────────────────────

  /// When `true`, vegetables render as coloured circles with name labels instead
  /// of sprites. Flip to `false` once TASK-VMG-011 sprite assets are in place.
  // TODO(art): set to false after TASK-VMG-011 sprite assets are added.
  static const bool kUsePlaceholderArt = true;

  /// When `true`, the IAP purchase flow uses a mock that auto-succeeds.
  /// Must be `false` in any build submitted to the Play Store.
  // ignore: avoid_redundant_argument_values — explicit for clarity
  static const bool kDebugIap = false;
}