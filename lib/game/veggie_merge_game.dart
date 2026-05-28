import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:flame/events.dart';



import '../core/constants/game_config.dart';
import '../core/constants/veggie_config.dart';
import '../domain/models/veggie_type.dart';
import 'components/container_walls.dart';
import 'components/danger_line.dart';
import 'components/veggie_body.dart';

/// The Flame/Forge2D game instance.
///
/// Owns the physics world and acts as the root component tree for the
/// game canvas. UI overlays (HUD, modals) are Flutter widgets stacked on top
/// of the [GameWidget] in GameScreen (TASK-VMG-007).
class VeggieMergeGame extends Forge2DGame with TapCallbacks {
  VeggieMergeGame()
      : super(
          gravity: Vector2(0, GameConfig.gravity),
          zoom: GameConfig.worldScale,
        );

  // — Layout geometry (set in onLoad after size is known) —

  /// Width of the container in logical pixels.
  late final double containerWidth;

  /// Height of the container in logical pixels.
  late final double containerHeight;

  /// X coordinate of the container's left wall (screen space).
  late final double containerLeft;

  /// X coordinate of the container's right wall (screen space).
  late final double containerRight;

  /// Y coordinate of the container's top edge (screen space).
  late final double containerTop;

  /// Y coordinate of the container's bottom edge (screen space).
  late final double containerBottom;

  /// Y coordinate of the danger line (screen space).
  late final double dangerLineY;

  Color backgroundColor() => const Color(0xFFF5F5F0);

  // — Component references (used by other systems) —

  ContainerWalls? _walls;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Derive container geometry from screen size and config ratios.
    final screenSize = size; // Flame Vector2, in logical pixels / worldScale
    // size in Forge2DGame is in world units (pixels / zoom).
    // Convert to screen pixels for layout arithmetic.
    final screenW = screenSize.x * GameConfig.worldScale;
    final screenH = screenSize.y * GameConfig.worldScale;

    containerWidth = screenW * GameConfig.containerWidthRatio;
    containerHeight = screenH * GameConfig.containerHeightRatio;
    containerLeft = (screenW - containerWidth) / 2;
    containerRight = containerLeft + containerWidth;

    // Vertically centre the container on screen.
    containerTop = (screenH - containerHeight) / 2;
    containerBottom = containerTop + containerHeight;
    dangerLineY = containerTop + GameConfig.dangerLineOffset;

    // Add walls and danger line.
    _walls = ContainerWalls(
      left: containerLeft,
      right: containerRight,
      top: containerTop,
      bottom: containerBottom,
    );
    await add(_walls!);

    await add(
      DangerLine(
        y: dangerLineY,
        left: containerLeft,
        right: containerRight,
      ),
    );
  }

  // — Public helpers —

  /// Spawn a vegetable body at the given screen-space [x] position, dropped
  /// from the top of the container.
  ///
  /// [x] is clamped to keep the body fully inside the container.
  Future<VeggieBody> spawnVeggie(VeggieType type, double x) async {
    final clampedX = x.clamp(
      containerLeft + type.radius,
      containerRight - type.radius,
    );

    final spawnY = containerTop + type.radius + 1;

    final body = VeggieBody(
      veggieType: type,
      initialPosition: Vector2(clampedX, spawnY),
    );

    await add(body);
    return body;
  }

  /// Provisional tap handler — spawns a Tier-1 Pea at the tap X position.
  /// Replaced by DropIndicator logic in TASK-VMG-004.
  @override
  void onTapDown(TapDownEvent event) {
    spawnVeggie(
      VeggieConfig.tier1,
      event.localPosition.x * GameConfig.worldScale,
    );
  }

  /// Remove all [VeggieBody] components from the world. Used by retry / continue.
  void clearVeggies() {
    children.whereType<VeggieBody>().toList().forEach(remove);
  }
}