import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

/// The HTTP boundary is faked, not the repository: `http_mock_adapter` swaps
/// `Dio`'s transport, so the code under test is the same code that ships and
/// the bytes it parses are a captured production response.
void main() {
  late Dio dio;
  late DioAdapter adapter;
  late CharacterRepositoryImpl repository;

  Object fixture(String name) =>
      jsonDecode(File('test/fixtures/$name.json').readAsStringSync()) as Object;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://rickandmortyapi.com/api/'));
    adapter = DioAdapter(dio: dio);
    repository = CharacterRepositoryImpl(dio);
  });

  test('the character list endpoint parses into domain models', () async {
    adapter.onGet(
      'character',
      (server) => server.reply(200, fixture('characters_page_1')),
    );

    final characters = await repository.fetchCharacters();

    expect(characters, hasLength(20));
    expect(characters.first.name, 'Rick Sanchez');
    expect(characters.first.originName, 'Earth (C-137)');
    expect(characters[1].type, isNull);
  });

  test('the single character endpoint parses into a domain model', () async {
    adapter.onGet(
      'character/2',
      (server) => server.reply(200, fixture('character_2')),
    );

    final character = await repository.fetchCharacter('2');

    expect(character.id, 2);
    expect(character.name, 'Morty Smith');
    expect(
      character.imageUrl,
      'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    );
  });
}
