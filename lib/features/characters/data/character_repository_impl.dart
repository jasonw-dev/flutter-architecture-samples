import 'package:dio/dio.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_dto.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

/// Talks to the API and hands back domain models.
///
/// There is no separate data source class between this and `Dio`: with one
/// backend it would only forward calls.
///
/// This is also where exceptions stop. It is the last layer that knows what
/// `DioException` is, so it is the layer that translates one into a [Failure];
/// everything above it sees a [Result] and nothing else.
class CharacterRepositoryImpl implements CharacterRepository {
  const CharacterRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<List<Character>>> fetchCharacters() {
    return _guard(() async {
      final response = await _dio.get<Map<String, dynamic>>('character');
      final results = response.data!['results'] as List<dynamic>;
      return [
        for (final json in results)
          CharacterDto.fromJson(json as Map<String, dynamic>).toDomain(),
      ];
    });
  }

  @override
  Future<Result<Character>> fetchCharacter(String id) {
    return _guard(() async {
      final response = await _dio.get<Map<String, dynamic>>('character/$id');
      return CharacterDto.fromJson(response.data!).toDomain();
    });
  }
}

/// Runs [request] and turns whatever goes wrong into a [Failure].
///
/// The bare `on Object` is deliberate: a malformed payload throws a cast error,
/// not a `DioException`, and a screen should say "something broke" rather than
/// crash on it.
Future<Result<T>> _guard<T>(Future<T> Function() request) async {
  try {
    return Ok(await request());
  } on DioException catch (e) {
    return Err(_failureFor(e));
  } on Object {
    return Err(const UnexpectedFailure());
  }
}

Failure _failureFor(DioException e) => switch (e.type) {
  DioExceptionType.connectionError ||
  DioExceptionType.connectionTimeout ||
  DioExceptionType.sendTimeout ||
  DioExceptionType.receiveTimeout => const NetworkFailure(),
  DioExceptionType.badResponse => ServerFailure(e.response?.statusCode),
  _ => const UnexpectedFailure(),
};
