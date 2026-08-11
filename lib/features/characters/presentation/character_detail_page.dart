import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/core/widgets/failure_view.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/character_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The detail screen. Same shape as the list: one `switch` over a sealed state,
/// no repository call, no local state.
class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
          builder: (context, state) => Text(
            state is CharacterDetailReady ? state.character.name : 'Character',
          ),
        ),
      ),
      body: BlocBuilder<CharacterDetailBloc, CharacterDetailState>(
        builder: (context, state) => switch (state) {
          CharacterDetailLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CharacterDetailFailed(:final failure) => FailureView(
            failure: failure,
            onRetry: () => context.read<CharacterDetailBloc>().add(
              CharacterDetailRequested(id),
            ),
          ),
          CharacterDetailReady(:final character) => _Details(character),
        },
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details(this.character);

  final Character character;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(
          character.imageUrl,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
        ListTile(title: const Text('Status'), subtitle: Text(character.status)),
        ListTile(
          title: const Text('Species'),
          subtitle: Text(character.species),
        ),
        if (character.type case final type?)
          ListTile(title: const Text('Type'), subtitle: Text(type)),
        ListTile(
          title: const Text('Origin'),
          subtitle: Text(character.originName),
        ),
      ],
    );
  }
}
