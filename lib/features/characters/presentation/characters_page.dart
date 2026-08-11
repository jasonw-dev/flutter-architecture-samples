import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/core/widgets/failure_view.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_bloc.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// The list screen. It reads state and sends events; it never calls a
/// repository, and it holds no state of its own.
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: BlocBuilder<CharactersBloc, CharactersState>(
        // Exhaustive by construction: `CharactersState` is sealed, so adding a
        // state without handling it here does not compile.
        builder: (context, state) => switch (state) {
          CharactersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CharactersFailed(:final failure) => FailureView(
            failure: failure,
            onRetry: () =>
                context.read<CharactersBloc>().add(const CharactersRequested()),
          ),
          CharactersReady(:final characters) => ListView.builder(
            itemCount: characters.length,
            itemBuilder: (context, index) {
              final character = characters[index];
              return ListTile(
                leading: ClipOval(
                  child: Image.network(
                    character.imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    // Without this a broken image throws, and in a widget test
                    // — where nothing answers an HTTP request — every row would.
                    errorBuilder: (_, _, _) => const Icon(Icons.person),
                  ),
                ),
                title: Text(character.name),
                subtitle: Text('${character.status} · ${character.species}'),
                onTap: () =>
                    context.go(CharactersRoutes.detail('${character.id}')),
              );
            },
          ),
        },
      ),
    );
  }
}
