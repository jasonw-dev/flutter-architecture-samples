import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';

/// Everything the app can ask about characters.
///
/// The implementation lives in `data/`. Presentation code depends on this and
/// never learns that HTTP is behind it, which is also what lets a test hand a
/// bloc a hand-written fake instead of a network stack.
///
/// Every method returns a [Result]: failure is part of the answer here, not an
/// exception the caller may or may not remember to catch.
abstract interface class CharacterRepository {
  Future<Result<List<Character>>> fetchCharacters();

  Future<Result<Character>> fetchCharacter(String id);
}
