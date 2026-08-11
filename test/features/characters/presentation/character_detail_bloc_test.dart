import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/character_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fake_character_repository.dart';

void main() {
  blocTest<CharacterDetailBloc, CharacterDetailState>(
    'requesting a character emits loading, then that character',
    build: () => CharacterDetailBloc(FakeCharacterRepository()),
    act: (bloc) => bloc.add(const CharacterDetailRequested('1')),
    expect: () => [
      isA<CharacterDetailLoading>(),
      isA<CharacterDetailReady>().having(
        (state) => state.character,
        'character',
        rick,
      ),
    ],
  );

  blocTest<CharacterDetailBloc, CharacterDetailState>(
    'a missing character ends in a failure state',
    build: () => CharacterDetailBloc(
      FakeCharacterRepository(one: const Err<Character>(ServerFailure(404))),
    ),
    act: (bloc) => bloc.add(const CharacterDetailRequested('999')),
    expect: () => [
      isA<CharacterDetailLoading>(),
      isA<CharacterDetailFailed>().having(
        (state) => state.failure,
        'failure',
        isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 404),
      ),
    ],
  );
}
