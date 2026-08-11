import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/core/network/api_client.dart';
import 'package:flutter_architecture_samples/features/characters/characters_di.dart';
import 'package:get_it/get_it.dart';

/// The service locator. Like the router, this is composition-root code — the
/// one place allowed to know every feature.
final getIt = GetIt.instance;

/// Registers everything the app can resolve. `main()` calls this once before
/// `runApp`; a test calls it to check the graph, then `getIt.reset()`.
///
/// Registration policy: everything is a lazy singleton, because everything
/// registered here is stateless and shared. Anything that holds per-screen
/// state belongs to that screen, not to the locator.
void configureDependencies() {
  getIt.registerLazySingleton<Dio>(createApiClient);
  registerCharacters(getIt);
}
