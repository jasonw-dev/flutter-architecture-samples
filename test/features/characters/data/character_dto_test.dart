import 'dart:convert';
import 'dart:io';

import 'package:flutter_architecture_samples/features/characters/data/character_dto.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_test/flutter_test.dart';

/// The fixtures are unedited responses from `rickandmortyapi.com`, so this
/// asserts against the real payload rather than a hand-written approximation.
Map<String, dynamic> _fixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('a real character response parses into a domain model', () {
    final character = CharacterDto.fromJson(_fixture('character_2')).toDomain();

    expect(
      character,
      const Character(
        id: 2,
        name: 'Morty Smith',
        status: 'Alive',
        species: 'Human',
        imageUrl: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        originName: 'unknown',
        type: null,
      ),
    );
  });

  test('an empty type becomes null', () {
    final json = _fixture('character_2');

    expect(CharacterDto.fromJson(json).type, '');
    expect(CharacterDto.fromJson(json).toDomain().type, isNull);
  });

  test('a non-empty type survives', () {
    final json = {..._fixture('character_2'), 'type': 'Parasite'};

    expect(CharacterDto.fromJson(json).toDomain().type, 'Parasite');
  });

  test('the nested origin is flattened to its name', () {
    final json = {
      ..._fixture('character_2'),
      'origin': {'name': 'Earth (C-137)', 'url': 'https://example.invalid/1'},
    };

    expect(CharacterDto.fromJson(json).toDomain().originName, 'Earth (C-137)');
  });
}
