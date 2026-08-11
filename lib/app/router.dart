import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_routes.dart';
import 'package:go_router/go_router.dart';

/// The composition root for navigation: the only place allowed to know every
/// feature. Features declare their own routes; this file lists them and hands
/// each one what it needs.
///
/// Dependencies arrive as arguments rather than being read from the locator
/// here, so a test can build the whole app on top of fakes without registering
/// anything.
GoRouter createRouter({required CharacterRepository characterRepository}) {
  return GoRouter(
    initialLocation: CharactersRoutes.list,
    routes: [...charactersRoutes(characterRepository)],
  );
}
