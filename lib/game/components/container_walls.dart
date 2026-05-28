import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants/game_config.dart';
import '../veggie_merge_game.dart';

/// Three static Box2D bodies that form the container:
/// left wall, right wall, and floor.
///
/// Coordinates supplied are in screen-space logical pixels; this component
/// converts them to Forge2D world units using [GameConfig.worldScale].
class ContainerWalls extends BodyComponent<VeggieMergeGame> {
  ContainerWalls({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;

  @override
  Body createBody() {
    final bodyDef = BodyDef()..type = BodyType.static;
    final body = world.createBody(bodyDef);

    final s = GameConfig.worldScale;

    // Convert screen-px corners to world units.
    final wLeft = left / s;
    final wRight = right / s;
    final wTop = top / s;
    final wBottom = bottom / s;

    final fixtureDef = FixtureDef(ChainShape())
      ..restitution = GameConfig.restitution
      ..friction = GameConfig.friction;

    // Bottom wall.
    (fixtureDef.shape as ChainShape).createChain([
      Vector2(wLeft, wBottom),
      Vector2(wRight, wBottom),
    ]);
    body.createFixture(fixtureDef);

    // Left wall.
    final leftFixture = FixtureDef(ChainShape())
      ..restitution = GameConfig.restitution
      ..friction = GameConfig.friction;

    (leftFixture.shape as ChainShape).createChain([
      Vector2(wLeft, wTop),
      Vector2(wLeft, wBottom),
    ]);

    body.createFixture(leftFixture);

    // Right wall.
    final rightFixture = FixtureDef(ChainShape())
      ..restitution = GameConfig.restitution
      ..friction = GameConfig.friction;

    (rightFixture.shape as ChainShape).createChain([
      Vector2(wRight, wTop),
      Vector2(wRight, wBottom),
    ]);

    body.createFixture(rightFixture);

    return body;
  }

  @override
  bool get debugMode => false;

  @override
void render(Canvas canvas) {
  final s = GameConfig.worldScale;
  final wLeft = left / s;
  final wRight = right / s;
  final wTop = top / s;
  final wBottom = bottom / s;

  // Pastel fill inside the container.
  canvas.drawRect(
    Rect.fromLTRB(wLeft, wTop, wRight, wBottom),
    Paint()..color = const Color(0xFFFFFFFF),
  );

  // Wall stroke — left, right, bottom (open top).
  final wallPaint = Paint()
    ..color = const Color(0xFF575757)
    ..strokeWidth = 0.25
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  final path = Path()
    ..moveTo(wLeft, wTop)
    ..lineTo(wLeft, wBottom)
    ..lineTo(wRight, wBottom)
    ..lineTo(wRight, wTop);

  canvas.drawPath(path, wallPaint);
  }
}