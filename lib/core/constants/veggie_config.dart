import 'dart:math';

import '../../../domain/models/veggie_type.dart';

/// Static configuration for the 10-tier vegetable chain.
///
/// Tier radii match the spec table. Spawn weights favour smaller tiers so the
/// game stays approachable: T1 40 %, T2 30 %, T3 20 %, T4 10 %.
abstract final class VeggieConfig {
  // — Tier definitions ───────────────────────────────────────────────────────

  static const VeggieType tier1 = VeggieType(
    tier: 1,
    name: 'Pea',
    radius: 24,
    scoreValue: 1,
    spritePath: 'assets/images/veggie_01_pea.png',
    isSpawnable: true,
  );

  static const VeggieType tier2 = VeggieType(
    tier: 2,
    name: 'Cherry Tomato',
    radius: 34,
    scoreValue: 2,
    spritePath: 'assets/images/veggie_02_cherry_tomato.png',
    isSpawnable: true,
  );

  static const VeggieType tier3 = VeggieType(
    tier: 3,
    name: 'Radish',
    radius: 44,
    scoreValue: 3,
    spritePath: 'assets/images/veggie_03_radish.png',
    isSpawnable: true,
  );

  static const VeggieType tier4 = VeggieType(
    tier: 4,
    name: 'Onion',
    radius: 56,
    scoreValue: 4,
    spritePath: 'assets/images/veggie_04_onion.png',
    isSpawnable: true,
  );

  static const VeggieType tier5 = VeggieType(
    tier: 5,
    name: 'Pepper',
    radius: 68,
    scoreValue: 5,
    spritePath: 'assets/images/veggie_05_pepper.png',
    isSpawnable: false,
  );

  static const VeggieType tier6 = VeggieType(
    tier: 6,
    name: 'Corn',
    radius: 82,
    scoreValue: 6,
    spritePath: 'assets/images/veggie_06_corn.png',
    isSpawnable: false,
  );

  static const VeggieType tier7 = VeggieType(
    tier: 7,
    name: 'Eggplant',
    radius: 96,
    scoreValue: 7,
    spritePath: 'assets/images/veggie_07_eggplant.png',
    isSpawnable: false,
  );

  static const VeggieType tier8 = VeggieType(
    tier: 8,
    name: 'Cabbage',
    radius: 112,
    scoreValue: 8,
    spritePath: 'assets/images/veggie_08_cabbage.png',
    isSpawnable: false,
  );

  static const VeggieType tier9 = VeggieType(
    tier: 9,
    name: 'Cauliflower',
    radius: 130,
    scoreValue: 9,
    spritePath: 'assets/images/veggie_09_cauliflower.png',
    isSpawnable: false,
  );

  static const VeggieType tier10 = VeggieType(
    tier: 10,
    name: 'Pumpkin',
    radius: 150,
    scoreValue: 10,
    spritePath: 'assets/images/veggie_10_pumpkin.png',
    isSpawnable: false,
  );

  // — Full ordered list ─────────────────────────────────────────────────────

  /// All 10 tiers in ascending order (index 0 = Tier 1).
  static const List<VeggieType> tiers = [
    tier1,
    tier2,
    tier3,
    tier4,
    tier5,
    tier6,
    tier7,
    tier8,
    tier9,
    tier10,
  ];

  // — Spawn pool (Tiers 1–4 only) ───────────────────────────────────────────

  /// Vegetables that may be given to the player as drop items.
  static const List<VeggieType> spawnPool = [tier1, tier2, tier3, tier4];

  /// Spawn weights corresponding to [spawnPool].
  /// Lower tiers appear more frequently for better game feel.
  /// T1=40%, T2=30%, T3=20%, T4=10% — must sum to 100.
  static const List<int> _spawnWeights = [40, 30, 20, 10];

  // — Helpers ────────────────────────────────────────────────────────────────

  /// Returns a randomly selected spawnable [VeggieType] using weighted
  /// probability (lower tiers are more likely).
  static VeggieType randomSpawnType([Random? random]) {
    final rng = random ?? Random();
    const total = 100; // sum of _spawnWeights
    final roll = rng.nextInt(total);

    int cumulative = 0;
    for (int i = 0; i < spawnPool.length; i++) {
      cumulative += _spawnWeights[i];
      if (roll < cumulative) return spawnPool[i];
    }

    return spawnPool.last;
  }

  /// Returns the [VeggieType] for [tier], or `null` if out of range.
  static VeggieType? forTier(int tier) {
    if (tier < 1 || tier > tiers.length) return null;
    return tiers[tier - 1];
  }

  /// Bonus score awarded when two Tier-10 (Pumpkin) vegetables merge.
  /// Equals double the tier value per spec BR-008.
  static const int pumpkinMergeBonus = 20;
}