import 'package:bloc/bloc.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

/// Something that happened, named subject + past-tense verb. An event says what
/// occurred, never what to do about it — deciding that is the bloc's job.
sealed class CharactersEvent {
  const CharactersEvent();
}

/// The list was asked for: on first build, and again on retry.
final class CharactersRequested extends CharactersEvent {
  const CharactersRequested();
}

/// Everything the screen can be. Sealed, so the widget's `switch` over it is
/// exhaustive and a new state cannot be forgotten in the UI.
sealed class CharactersState {
  const CharactersState();
}

final class CharactersLoading extends CharactersState {
  const CharactersLoading();
}

final class CharactersReady extends CharactersState {
  const CharactersReady(this.characters);

  final List<Character> characters;
}

final class CharactersFailed extends CharactersState {
  const CharactersFailed(this.failure);

  final Failure failure;
}

/// Turns events into states, and nothing else.
///
/// It talks to [CharacterRepository] directly. There is no use case layer in
/// between: with one call per event, a use case would be a one-line forward,
/// and the boundary it would protect is already the repository interface.
///
/// This file imports `package:bloc`, not `package:flutter_bloc` — no widget,
/// no `BuildContext`, so the whole class is testable without a Flutter binding.
class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc(this._repository) : super(const CharactersLoading()) {
    on<CharactersRequested>(_onRequested);
  }

  final CharacterRepository _repository;

  Future<void> _onRequested(
    CharactersRequested event,
    Emitter<CharactersState> emit,
  ) async {
    emit(const CharactersLoading());
    emit(switch (await _repository.fetchCharacters()) {
      Ok(:final value) => CharactersReady(value),
      Err(:final failure) => CharactersFailed(failure),
    });
  }
}
