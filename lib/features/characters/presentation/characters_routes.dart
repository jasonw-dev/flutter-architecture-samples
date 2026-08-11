import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/character_detail_bloc.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/character_detail_page.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_bloc.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The paths this feature answers to. Other features navigate here by calling
/// these — they never import the pages themselves.
abstract final class CharactersRoutes {
  static const list = '/characters';

  static String detail(String id) => '$list/$id';
}

/// The route table this feature owns, composed into the app's router.
///
/// It is handed its [repository] rather than reading the service locator: the
/// locator is composition-root code, and a feature that imports `lib/app/`
/// would point the dependency arrow backwards.
///
/// Blocs are created here, one per screen, and die with the route. That is why
/// they are not registered in the locator — the locator holds shared, stateless
/// things, and a bloc is neither.
List<RouteBase> charactersRoutes(CharacterRepository repository) => [
  GoRoute(
    path: CharactersRoutes.list,
    builder: (context, state) => BlocProvider(
      create: (_) =>
          CharactersBloc(repository)..add(const CharactersRequested()),
      child: const CharactersPage(),
    ),
    routes: [
      GoRoute(
        path: ':id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return BlocProvider(
            create: (_) => CharacterDetailBloc(repository)
              ..add(CharacterDetailRequested(id)),
            child: CharacterDetailPage(id: id),
          );
        },
      ),
    ],
  ),
];
