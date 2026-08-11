import 'package:bloc/bloc.dart';
import 'package:flutter_architecture_samples/core/failure.dart';
import 'package:flutter_architecture_samples/core/result.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

sealed class CharacterDetailEvent {
  const CharacterDetailEvent();
}

/// One character was asked for, by id.
final class CharacterDetailRequested extends CharacterDetailEvent {
  const CharacterDetailRequested(this.id);

  final String id;
}

sealed class CharacterDetailState {
  const CharacterDetailState();
}

final class CharacterDetailLoading extends CharacterDetailState {
  const CharacterDetailLoading();
}

final class CharacterDetailReady extends CharacterDetailState {
  const CharacterDetailReady(this.character);

  final Character character;
}

final class CharacterDetailFailed extends CharacterDetailState {
  const CharacterDetailFailed(this.failure);

  final Failure failure;
}

/// The detail screen's state, fetched from the id in the URL.
///
/// The list could have handed the whole character over instead, which would
/// save a request. It does not: `/characters/2` opened from a link or a cold
/// start has an id and nothing else, and a screen that works one way from the
/// list and another way from a link is two screens.
class CharacterDetailBloc
    extends Bloc<CharacterDetailEvent, CharacterDetailState> {
  CharacterDetailBloc(this._repository)
    : super(const CharacterDetailLoading()) {
    on<CharacterDetailRequested>(_onRequested);
  }

  final CharacterRepository _repository;

  Future<void> _onRequested(
    CharacterDetailRequested event,
    Emitter<CharacterDetailState> emit,
  ) async {
    emit(const CharacterDetailLoading());
    emit(switch (await _repository.fetchCharacter(event.id)) {
      Ok(:final value) => CharacterDetailReady(value),
      Err(:final failure) => CharacterDetailFailed(failure),
    });
  }
}
