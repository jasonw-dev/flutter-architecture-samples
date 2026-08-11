import 'package:flutter_architecture_samples/core/failure.dart';

/// The outcome of something that can fail.
///
/// Repositories return this rather than throwing, so a caller cannot forget the
/// failure path: there is no way to reach the value without first saying what
/// happens when there isn't one. Exceptions stop at the layer that knows the
/// transport — see `CharacterRepositoryImpl`.
sealed class Result<T> {
  const Result();
}

/// It worked, and [value] is the answer.
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

/// It did not work, and [failure] says why.
///
/// Named `Err` rather than `Error` because `dart:core` already owns that name
/// for something different — a bug, not a handled outcome.
final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
