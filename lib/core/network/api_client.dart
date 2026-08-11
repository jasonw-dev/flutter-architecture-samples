import 'package:dio/dio.dart';

/// The app's single HTTP client. Features are handed this `Dio` and never build
/// their own, so the base URL and timeouts are set in exactly one place.
///
/// Turning a failed request into something a screen can show is stage 4's job;
/// this file only configures the transport.
Dio createApiClient() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
}
