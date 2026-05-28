import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/constants/veggie_config.dart';
import '../../game/veggie_merge_game.dart';

/// Hosts the Flame [GameWidget] for [VeggieMergeGame].
///
/// Flutter HUD overlays (score, next-veggie preview) will be stacked on top
/// of the [GameWidget] in TASK-VMG-007.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final VeggieMergeGame _game;

  @override
  void initState() {
    super.initState();
    _game = VeggieMergeGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: _game,

        // Tap anywhere to drop a random test veggie — removed in TASK-VMG-004
        // when the full drop controller replaces this provisional listener.
        overlayBuilderMap:
          <String, Widget Function(BuildContext, VeggieMergeGame)> {},
      ),
    );
  }
}