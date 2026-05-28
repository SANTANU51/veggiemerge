import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants/game_config.dart';
import '../../domain/models/veggie_type.dart';
import '../veggie_merge_game.dart';

/// A dynamic circular physics body representing one vegetable in the world.
///
/// Renders as a filled circle with a tier-specific placeholder colour when
/// [GameConfig.kUsePlaceholderArt] is `true`. Sprite rendering is wired in
/// TASK-VMG-011.
/// TODO(art): replace placeholder circle rendering with sprite in TASK-VMG-011.
class VeggieBody extends BodyComponent<VeggieMergeGame>
    with ContactCallbacks {
  VeggieBody({
    required this.veggieType,
    required this.initialPosition,
  });

  /// The vegetable tier this body represents.
  final VeggieType veggieType;

  /// Spawn position in screen-space logical pixels.
  final Vector2 initialPosition;

  // — Placeholder colour palette — one per tier —
  static const List<Color> _tierColors = [
    Color(0xFF8BC34A), // T1 Pea          — light green
    Color(0xFFE53935), // T2 Cherry Tomato — red
    Color(0xFFE91E63), // T3 Radish       — pink-red
    Color(0xFFFFA825), // T4 Onion        — amber
    Color(0xFFFF5722), // T5 Pepper       — deep orange
    Color(0xFFFFEB3B), // T6 Corn         — yellow
    Color(0xFF673AB7), // T7 Eggplant     — deep purple
    Color(0xFF4CAF50), // T8 Cabbage      — green
    Color(0xFFF5F5F5), // T9 Cauliflower  — off-white
    Color(0xFFFF9800), // T10 Pumpkin     — orange
  ];

  Color get _color => _tierColors[(veggieType.tier - 1).clamp(0, 9)];

  /// Radius in Forge2D world units.
  double get _worldRadius =>
      veggieType.radius / GameConfig.worldScale;

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = initialPosition / GameConfig.worldScale
      ..userData = this;

    final body = world.createBody(bodyDef);

    final shape = CircleShape()..radius = _worldRadius;

    final fixtureDef = FixtureDef(shape)
      ..density = GameConfig.density
      ..restitution = GameConfig.restitution
      ..friction = GameConfig.friction;

    body.createFixture(fixtureDef);

    return body;
  }

  @override
  void render(Canvas canvas) {
    if (!GameConfig.kUsePlaceholderArt) {
      // Sprite rendering will replace this block in TASK-VMG-011.
      return;
    }

    final r = _worldRadius;

    // Drop shadow.
    canvas.drawCircle(
      Offset(r * 0.08, r * 0.12),
      r,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18),
    );

    // Filled circle body.
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()..color = _color,
    );

    // Outline.
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.04,
    );

    // Tier label.
    final tp = TextPainter(
      text: TextSpan(
        text: veggieType.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: r * 0.45,
          fontWeight: FontWeight.bold,
          shadows: const [Shadow(blurRadius: 2)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(-tp.width / 2, -tp.height / 2),
    );
  }
}