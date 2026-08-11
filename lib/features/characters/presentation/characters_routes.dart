import 'package:flutter_architecture_samples/features/characters/presentation/character_detail_page.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_page.dart';
import 'package:go_router/go_router.dart';

/// The paths this feature answers to. Other features navigate here by calling
/// these — they never import the pages themselves.
abstract final class CharactersRoutes {
  static const list = '/characters';

  static String detail(String id) => '$list/$id';
}

/// The route table this feature owns, composed into the app's router.
final charactersRoutes = <RouteBase>[
  GoRoute(
    path: CharactersRoutes.list,
    builder: (context, state) => const CharactersPage(),
    routes: [
      GoRoute(
        path: ':id',
        builder: (context, state) => CharacterDetailPage(
          id: state.pathParameters['id']!,
        ),
      ),
    ],
  ),
];
