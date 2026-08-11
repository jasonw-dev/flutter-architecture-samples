import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_repository_impl.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';
import 'package:get_it/get_it.dart';

/// What this feature contributes to the object graph, the same way
/// `charactersRoutes` is what it contributes to the router: the feature owns
/// the list, `lib/app/` only calls it.
///
/// It sits at the feature root rather than in a layer because it is the one
/// file that spans them.
void registerCharacters(GetIt getIt) {
  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(getIt<Dio>()),
  );
}
