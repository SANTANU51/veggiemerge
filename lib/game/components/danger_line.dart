import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants/game_config.dart';
import '../veggie_merge_game.dart';

/// A dashed horizontal line rendered at the danger Y position.
///
/// Coordinates are in Forge2D world units. A vegetable whose top edge exceeds
/// this line starts the [GameConfig.dangerThresholdSeconds] countdown.
class DangerLine extends Component
    with HasGameReference<VeggieMergeGame> {
  DangerLine({
    required double y,
    required double left,
    required double right,
  })  : _y = y / GameConfig.worldScale,
        _left = left / GameConfig.worldScale,
        _right = right / GameConfig.worldScale;

  final double _y;
  final double _left;
  final double _right;

  static const Color _lineColor = Color(0xFFE53935); // red
  static const double _dashLength = 0.8; // world units
  static const double _gapLength = 0.4; // world units
  static const double _strokeWidth = 0.18; // world units

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = _lineColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    double x = _left;
    bool drawing = true;

    while (x < _right) {
      final end =
          (x + (drawing ? _dashLength : _gapLength))
              .clamp(_left, _right);

      if (drawing) {
        canvas.drawLine(
          Offset(x, _y),
          Offset(end, _y),
          paint,
        );
      }

      x = end;
      drawing = !drawing;
    }
  }
}