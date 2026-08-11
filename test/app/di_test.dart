import 'package:flutter_architecture_samples/app/di.dart';
import 'package:flutter_architecture_samples/features/characters/data/character_repository_impl.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(configureDependencies);
  tearDown(getIt.reset);

  test('the repository resolves, wired to the real client', () {
    expect(getIt<CharacterRepository>(), isA<CharacterRepositoryImpl>());
  });

  test('registrations are singletons, so the graph is shared', () {
    expect(getIt<CharacterRepository>(), same(getIt<CharacterRepository>()));
  });
}
