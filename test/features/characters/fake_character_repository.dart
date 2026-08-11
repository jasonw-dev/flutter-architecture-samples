import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

/// A repository that answers from memory.
///
/// Hand-written rather than generated: `CharacterRepository` has two methods,
/// and a mocking library would cost a dependency and a `when`/`verify` DSL to
/// save these few lines.
class FakeCharacterRepository implements CharacterRepository {
  FakeCharacterRepository({Result<List<Character>>? list, Result<Character>? one})
    : _list = list ?? Ok([rick, morty]),
      _one = one ?? const Ok(rick);

  final Result<List<Character>> _list;
  final Result<Character> _one;

  @override
  Future<Result<List<Character>>> fetchCharacters() async => _list;

  @override
  Future<Result<Character>> fetchCharacter(String id) async => _one;
}

const rick = Character(
  id: 1,
  name: 'Rick Sanchez',
  status: 'Alive',
  species: 'Human',
  imageUrl: 'https://example.test/1.jpeg',
  originName: 'Earth (C-137)',
);

const morty = Character(
  id: 2,
  name: 'Morty Smith',
  status: 'Alive',
  species: 'Human',
  imageUrl: 'https://example.test/2.jpeg',
  originName: 'unknown',
);

const offline = Err<List<Character>>(NetworkFailure());
