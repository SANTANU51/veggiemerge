import 'package:get_it/get_it.dart';

/// Global service locator instance.
/// Access via [getIt<T>()] throughout the app.
final GetIt getIt = GetIt.instance;

/// Registers all dependencies.
/// Called once in [main] before [runApp].
/// Additional registrations are added as tasks complete.
void setupServiceLocator() {
  // TASK-VMG-002: VeggieConfig, GameConfig
  // TASK-VMG-008: HighScoreRepository
  // TASK-VMG-010: PurchaseManager
}