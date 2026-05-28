import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:veggie_merge/core/constants/game_config.dart';
import 'package:veggie_merge/core/constants/veggie_config.dart';
import 'package:veggie_merge/domain/models/veggie_type.dart';

void main() {
  // — VeggieType ─────────────────────────────────────────────────────────────

  group('VeggieType', () {
    test('test_equality_sameTier_returnsTrue', () {
      const a = VeggieType(
        tier: 1,
        name: 'Pea',
        radius: 24,
        scoreValue: 1,
        spritePath: '',
        isSpawnable: true,
      );

      const b = VeggieType(
        tier: 1,
        name: 'Pea',
        radius: 24,
        scoreValue: 1,
        spritePath: '',
        isSpawnable: true,
      );

      expect(a, equals(b));
    });

    test('test_equality_differentTier_returnsFalse', () {
      expect(VeggieConfig.tier1, isNot(equals(VeggieConfig.tier2)));
    });

    test('test_toString_containsTierAndName', () {
      expect(VeggieConfig.tier1.toString(), contains('1'));
      expect(VeggieConfig.tier1.toString(), contains('Pea'));
    });
  });

  // — VeggieConfig.tiers ────────────────────────────────────────────────────

  group('VeggieConfig.tiers', () {
    test('test_tiersCount_exactlyTen', () {
      expect(VeggieConfig.tiers.length, 10);
    });

    test('test_tierOrdering_ascendingTierNumbers', () {
      for (int i = 0; i < VeggieConfig.tiers.length; i++) {
        expect(VeggieConfig.tiers[i].tier, i + 1);
      }
    });

    test('test_tierOrdering_ascendingRadii', () {
      for (int i = 1; i < VeggieConfig.tiers.length; i++) {
        expect(
          VeggieConfig.tiers[i].radius,
          greaterThan(VeggieConfig.tiers[i - 1].radius),
          reason: 'Tier ${i + 1} radius should be > Tier $i radius',
        );
      }
    });

    test('test_scoreValue_equalsTier_forAllTiers', () {
      for (final veggie in VeggieConfig.tiers) {
        expect(
          veggie.scoreValue,
          veggie.tier,
          reason: '${veggie.name} scoreValue should equal its tier',
        );
      }
    });

    test('test_tier10_isPumpkin', () {
      expect(VeggieConfig.tier10.name, 'Pumpkin');
      expect(VeggieConfig.tier10.tier, 10);
    });

    test('test_tier1_isPea', () {
      expect(VeggieConfig.tier1.name, 'Pea');
      expect(VeggieConfig.tier1.tier, 1);
    });

    test('test_spritePaths_allNonEmpty', () {
      for (final veggie in VeggieConfig.tiers) {
        expect(
          veggie.spritePath,
          isNotEmpty,
          reason: '${veggie.name} must have a spritePath',
        );
      }
    });
  });

  // — VeggieConfig.spawnPool ────────────────────────────────────────────────

  group('VeggieConfig.spawnPool', () {
    test('test_spawnPoolCount_exactlyFour', () {
      expect(VeggieConfig.spawnPool.length, 4);
    });

    test('test_spawnPool_containsOnlyTiers1To4', () {
      for (final veggie in VeggieConfig.spawnPool) {
        expect(veggie.tier, inInclusiveRange(1, 4));
        expect(veggie.isSpawnable, isTrue);
      }
    });

    test('test_spawnPool_excludesTiers5To10', () {
      final spawnableTiers =
          VeggieConfig.spawnPool.map((v) => v.tier).toSet();

      for (int tier = 5; tier <= 10; tier++) {
        expect(
          spawnableTiers,
          isNot(contains(tier)),
          reason: 'Tier $tier must not be in the spawn pool',
        );
      }
    });

    test('test_nonSpawnableTiers_isSpawnableFalse', () {
      final nonSpawnable =
          VeggieConfig.tiers.where((v) => !v.isSpawnable).toList();

      expect(nonSpawnable.length, 6); // tiers 5-10

      for (final veggie in nonSpawnable) {
        expect(veggie.tier, greaterThanOrEqualTo(5));
      }
    });
  });

  // — VeggieConfig.randomSpawnType ──────────────────────────────────────────

  group('VeggieConfig.randomSpawnType', () {
    test('test_randomSpawnType_alwaysReturnsSpawnableType', () {
      for (int i = 0; i < 200; i++) {
        final result = VeggieConfig.randomSpawnType();

        expect(result.isSpawnable, isTrue);
        expect(result.tier, inInclusiveRange(1, 4));
      }
    });

    test(
        'test_randomSpawnType_withSeededRandom_returnsDeterministicResult',
        () {
      // Same seed must produce same sequence.
      final rng1 = Random(42);
      final rng2 = Random(42);

      for (int i = 0; i < 20; i++) {
        expect(
          VeggieConfig.randomSpawnType(rng1).tier,
          VeggieConfig.randomSpawnType(rng2).tier,
        );
      }
    });

    test('test_randomSpawnType_producesAllFourTiersOverManyRolls', () {
      final seen = <int>{};
      final rng = Random(0);

      for (int i = 0; i < 500; i++) {
        seen.add(VeggieConfig.randomSpawnType(rng).tier);
      }

      expect(seen, containsAll([1, 2, 3, 4]));
    });
  });

  // — VeggieConfig.forTier ──────────────────────────────────────────────────

  group('VeggieConfig.forTier', () {
    test('test_forTier_validTier_returnsCorrectVeggie', () {
      for (int t = 1; t <= 10; t++) {
        final veggie = VeggieConfig.forTier(t);

        expect(veggie, isNotNull);
        expect(veggie!.tier, t);
      }
    });

    test('test_forTier_tierZero_returnsNull', () {
      expect(VeggieConfig.forTier(0), isNull);
    });

    test('test_forTier_tierElevenOrMore_returnsNull', () {
      expect(VeggieConfig.forTier(11), isNull);
      expect(VeggieConfig.forTier(99), isNull);
    });
  });

  // — VeggieConfig.pumpkinMergeBonus ────────────────────────────────────────

  group('VeggieConfig.pumpkinMergeBonus', () {
    test('test_pumpkinMergeBonus_isDoubleTier10Value', () {
      expect(
        VeggieConfig.pumpkinMergeBonus,
        VeggieConfig.tier10.scoreValue * 2,
      );
    });
  });

  // — GameConfig ────────────────────────────────────────────────────────────

  group('GameConfig', () {
    test('test_containerWidthRatio_is0point90', () {
      expect(GameConfig.containerWidthRatio, 0.90);
    });

    test('test_containerHeightRatio_is0point75', () {
      expect(GameConfig.containerHeightRatio, 0.75);
    });

    test('test_dangerLineOffset_is60', () {
      expect(GameConfig.dangerLineOffset, 60.0);
    });

    test('test_dangerThreshold_is2seconds', () {
      expect(GameConfig.dangerThresholdSeconds, 2.0);
    });

    test('test_gravity_is30', () {
      expect(GameConfig.gravity, 30.0);
    });

    test('test_worldScale_is10', () {
      expect(GameConfig.worldScale, 10.0);
    });

    test('test_restitution_is0point35', () {
      expect(GameConfig.restitution, 0.35);
    });

    test('test_friction_is0point6', () {
      expect(GameConfig.friction, 0.6);
    });

    test('test_kDebugIap_isFalseInProduction', () {
      // kDebugIap must never be true in a committed build.
      expect(GameConfig.kDebugIap, isFalse);
    });
  });
}