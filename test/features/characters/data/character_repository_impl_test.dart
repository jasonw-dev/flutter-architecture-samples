import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_repository_impl.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
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

    final result = await repository.fetchCharacters();

    final characters = (result as Ok<List<Character>>).value;
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

    final result = await repository.fetchCharacter('2');

    final character = (result as Ok<Character>).value;
    expect(character.id, 2);
    expect(character.name, 'Morty Smith');
    expect(
      character.imageUrl,
      'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
    );
  });

  test('an unreachable server becomes a NetworkFailure, not a throw', () async {
    adapter.onGet(
      'character',
      (server) => server.throws(
        0,
        DioException.connectionError(
          requestOptions: RequestOptions(path: 'character'),
          reason: 'no route to host',
        ),
      ),
    );

    final result = await repository.fetchCharacters();

    expect(result, isA<Err<List<Character>>>());
    expect((result as Err<List<Character>>).failure, isA<NetworkFailure>());
  });

  test('a rejected request carries the status code through', () async {
    adapter.onGet('character/999', (server) => server.reply(404, null));

    final result = await repository.fetchCharacter('999');

    final failure = (result as Err<Character>).failure;
    expect(failure, isA<ServerFailure>());
    expect((failure as ServerFailure).statusCode, 404);
  });

  test('a payload that does not parse becomes an UnexpectedFailure', () async {
    adapter.onGet(
      'character/2',
      (server) => server.reply(200, {'id': 'not a number'}),
    );

    final result = await repository.fetchCharacter('2');

    expect((result as Err<Character>).failure, isA<UnexpectedFailure>());
  });
}
