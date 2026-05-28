import 'package:get_it/get_it.dart';

/// Global service locator instance.
/// Access via [getIt<T>()] throughout the app.
final GetIt getIt = GetIt.instance;

/// Registers all dependencies.
/// Called once in [main] before [runApp].
/// Additional registrations are added as tasks complete.
void setupServiceLocator() {
  // TASK-VMG-002 — VeggieConfig and GameConfig are pure static classes;
  // no DI registration needed. Access directly as VeggieConfig.tiers etc.

  // TASK-VMG-008: register HighScoreRepository
  // getIt.registerLazySingleton<HighScoreRepository>(
  //   () => HighScoreRepositoryImpl(),
  // );

  // TASK-VMG-010: register PurchaseManager
  // getIt.registerLazySingleton<PurchaseManager>(
  //   () => GameConfig.kDebugIap
  //       ? MockPurchaseManager()
  //       : InAppPurchaseManager(),
  // );
}