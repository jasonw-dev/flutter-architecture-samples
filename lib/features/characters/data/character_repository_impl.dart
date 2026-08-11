import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_dto.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

/// Talks to the API and hands back domain models.
///
/// There is no separate data source class between this and `Dio`: with one
/// backend it would only forward calls. A failed request throws `DioException`
/// for now — stage 4 decides what callers see instead.
class CharacterRepositoryImpl implements CharacterRepository {
  const CharacterRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Character>> fetchCharacters() async {
    final response = await _dio.get<Map<String, dynamic>>('character');
    final results = response.data!['results'] as List<dynamic>;
    return [
      for (final json in results)
        CharacterDto.fromJson(json as Map<String, dynamic>).toDomain(),
    ];
  }

  @override
  Future<Character> fetchCharacter(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('character/$id');
    return CharacterDto.fromJson(response.data!).toDomain();
  }
}
