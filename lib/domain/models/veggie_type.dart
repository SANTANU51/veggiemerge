import 'package:flutter/foundation.dart';

/// Represents a single tier in the 10-tier vegetable chain.
///
/// Instances are immutable constants defined in [VeggieConfig].
@immutable
class VeggieType {
  const VeggieType({
    required this.tier,
    required this.name,
    required this.radius,
    required this.scoreValue,
    required this.spritePath,
    required this.isSpawnable,
  });

  /// Tier number 1–10. Tier 1 is the smallest (Pea), Tier 10 is the largest (Pumpkin).
  final int tier;

  /// Display name, e.g. "Pea", "Cherry Tomato", "Pumpkin".
  final String name;

  /// Physics body radius in logical pixels.
  final double radius;

  /// Points awarded when this vegetable is created via a merge.
  /// Always equals [tier], except Tier-10 merges award a separate bonus.
  final int scoreValue;

  /// Asset path for the sprite image. Sprites are loaded in TASK-VMG-011.
  final String spritePath;

  /// Whether this tier can appear as a drop item.
  /// Only Tiers 1–4 are spawnable; higher tiers are merge-only.
  final bool isSpawnable;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VeggieType &&
          runtimeType == other.runtimeType &&
          tier == other.tier;

  @override
  int get hashCode => tier.hashCode;

  @override
 String toString() => 'VeggieType(tier: $tier, name: $name)';
}