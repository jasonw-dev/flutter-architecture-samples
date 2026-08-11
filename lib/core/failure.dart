/// Why a request could not be answered, in terms a screen can act on.
///
/// Sealed on purpose: a `switch` over it is exhaustive, so adding a case here
/// turns every screen that renders failures into a compile error instead of
/// letting one fall through to a silent default.
///
/// Three cases is the whole list. A failure only earns its own case when a
/// screen would say something different about it.
sealed class Failure {
  const Failure();
}

/// The server was never reached: no connection, or it took too long.
final class NetworkFailure extends Failure {
  const NetworkFailure();
}

/// The server was reached and refused. [statusCode] is null when the response
/// carried none.
final class ServerFailure extends Failure {
  const ServerFailure(this.statusCode);

  final int? statusCode;
}

/// Anything else — a payload that did not parse, a bug on our side.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}

extension FailureMessage on Failure {
  /// What to put on screen. One exhaustive switch, so a new [Failure] cannot
  /// ship without someone deciding what it says.
  ///
  /// English literals live here because `main` has no localization. This
  /// extension is the seam a localization branch replaces — one file, not every
  /// screen that renders an error.
  String get message => switch (this) {
    NetworkFailure() => "Can't reach the server. Check your connection.",
    ServerFailure(:final statusCode) =>
      'The server refused the request${statusCode == null ? '' : ' ($statusCode)'}.',
    UnexpectedFailure() => 'Something went wrong.',
  };
}
