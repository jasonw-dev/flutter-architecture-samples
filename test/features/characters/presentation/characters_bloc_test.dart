import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_character_repository.dart';

void main() {
  blocTest<CharactersBloc, CharactersState>(
    'requesting the list emits loading, then the characters',
    build: () => CharactersBloc(FakeCharacterRepository()),
    act: (bloc) => bloc.add(const CharactersRequested()),
    expect: () => [
      isA<CharactersLoading>(),
      isA<CharactersReady>().having(
        (state) => state.characters,
        'characters',
        [rick, morty],
      ),
    ],
  );

  blocTest<CharactersBloc, CharactersState>(
    'a failed request ends in a failure state, not an exception',
    build: () => CharactersBloc(FakeCharacterRepository(list: offline)),
    act: (bloc) => bloc.add(const CharactersRequested()),
    expect: () => [
      isA<CharactersLoading>(),
      isA<CharactersFailed>().having(
        (state) => state.failure,
        'failure',
        isA<NetworkFailure>(),
      ),
    ],
  );

  blocTest<CharactersBloc, CharactersState>(
    'retrying re-runs the request',
    build: () => CharactersBloc(FakeCharacterRepository()),
    act: (bloc) => bloc
      ..add(const CharactersRequested())
      ..add(const CharactersRequested()),
    expect: () => [
      isA<CharactersLoading>(),
      isA<CharactersReady>(),
      isA<CharactersLoading>(),
      isA<CharactersReady>(),
    ],
  );
}
