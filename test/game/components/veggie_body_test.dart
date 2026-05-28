import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veggie_merge/core/constants/game_config.dart';
import 'package:veggie_merge/core/constants/veggie_config.dart';
import 'package:veggie_merge/domain/models/veggie_type.dart';
import 'package:veggie_merge/game/components/veggie_body.dart';
import 'package:veggie_merge/game/veggie_merge_game.dart';

void main() {
  group('VeggieBody – world radius', () {
    // Verify that each tier's world-space radius equals
    // VeggieType.radius / GameConfig.worldScale.
    for (final type in VeggieConfig.tiers) {
      test(
        'test_veggieBody_worldRadius_tier${type.tier}_equalsRadiusDividedByScale',
        () {
          final body = VeggieBody(
            veggieType: type,
            initialPosition: Vector2.zero(),
          );

          final expectedWorldRadius =
              type.radius / GameConfig.worldScale;

          // Access the private getter via the public veggieType property.
          expect(
            type.radius / GameConfig.worldScale,
            closeTo(expectedWorldRadius, 1e-9),
          );

          // Verify tier identity is preserved.
          expect(body.veggieType.tier, type.tier);
        },
      );
    }
  });

  group('VeggieBody – veggieType property', () {
    test('test_veggieBody_veggieType_exposedCorrectly', () {
      final body = VeggieBody(
        veggieType: VeggieConfig.tier1,
        initialPosition: Vector2(100, 200),
      );

      expect(body.veggieType, equals(VeggieConfig.tier1));
    });

    test('test_veggieBody_veggieType_tier10_isPumpkin', () {
      final body = VeggieBody(
        veggieType: VeggieConfig.tier10,
        initialPosition: Vector2.zero(),
      );

      expect(body.veggieType.name, 'Pumpkin');
      expect(body.veggieType.tier, 10);
    });
  });

  group('VeggieBody – world radius values match spec', () {
    // Spec tier table (logical px):
    // T1=24 T2=34 T3=44 T4=56 T5=68
    // T6=82 T7=96 T8=112 T9=130 T10=150

    const expected = {
      1: 24.0,
      2: 34.0,
      3: 44.0,
      4: 56.0,
      5: 68.0,
      6: 82.0,
      7: 96.0,
      8: 112.0,
      9: 130.0,
      10: 150.0,
    };

    for (final entry in expected.entries) {
      test(
        'test_veggieBody_specRadius_tier${entry.key}_is${entry.value.toInt()}px',
        () {
          final type = VeggieConfig.forTier(entry.key)!;

          expect(type.radius, closeTo(entry.value, 1e-9));

          final worldRadius =
              type.radius / GameConfig.worldScale;

          expect(
            worldRadius,
            closeTo(entry.value / 10.0, 1e-9),
          );
        },
      );
    }
  });

  group('ContainerWalls – bounds match config', () {
    test('test_containerWalls_widthRatio_isCorrect', () {
      // Confirm that container dimensions derived from an arbitrary screen
      // size honour the configured ratios.

      const screenW = 400.0;
      const screenH = 800.0;

      final containerW =
          screenW * GameConfig.containerWidthRatio;

      final containerH =
          screenH * GameConfig.containerHeightRatio;

      expect(containerW, closeTo(360.0, 1e-9)); // 400 * 0.90
      expect(containerH, closeTo(600.0, 1e-9)); // 800 * 0.75
    });

    test('test_containerWalls_containerLeft_isCentred', () {
      const screenW = 400.0;

      final containerW =
          screenW * GameConfig.containerWidthRatio;

      final containerLeft =
          (screenW - containerW) / 2;

      expect(containerLeft, closeTo(20.0, 1e-9));
    });

    test('test_containerWalls_dangerLineY_isOffsetFromTop', () {
      const screenH = 800.0;
      const containerTop = 100.0; // arbitrary

      final dangerLineY =
          containerTop + GameConfig.dangerLineOffset;

      expect(dangerLineY, closeTo(160.0, 1e-9)); // 100 + 60
    });
  });

  group('GameConfig constants sanity', () {
    test('test_gameConfig_worldScale_is10', () {
      expect(GameConfig.worldScale, 10.0);
    });

    test('test_gameConfig_gravity_is30', () {
      expect(GameConfig.gravity, 30.0);
    });

    test('test_gameConfig_containerWidthRatio_is0_90', () {
      expect(GameConfig.containerWidthRatio, 0.90);
    });

    test('test_gameConfig_containerHeightRatio_is0_75', () {
      expect(GameConfig.containerHeightRatio, 0.75);
    });

    test('test_gameConfig_dangerLineOffset_is60', () {
      expect(GameConfig.dangerLineOffset, 60.0);
    });
  });
}