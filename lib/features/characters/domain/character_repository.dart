import 'package:flutter_architecture_samples/features/characters/domain/character.dart';

/// Everything the app can ask about characters.
///
/// The implementation lives in `data/`. Presentation code depends on this and
/// never learns that HTTP is behind it, which is also what lets a test hand a
/// bloc a hand-written fake instead of a network stack.
abstract interface class CharacterRepository {
  Future<List<Character>> fetchCharacters();

  Future<Character> fetchCharacter(String id);
}
