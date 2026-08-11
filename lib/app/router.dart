import 'package:flutter_architecture_samples/features/characters/presentation/characters_routes.dart';
import 'package:go_router/go_router.dart';

/// The composition root for navigation: the only place allowed to know every
/// feature. Features declare their own routes; this file just lists them.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: CharactersRoutes.list,
    routes: [...charactersRoutes],
  );
}
