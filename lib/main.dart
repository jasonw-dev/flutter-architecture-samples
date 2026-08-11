import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/app/app.dart';
import 'package:flutter_architecture_samples/app/di.dart';
import 'package:flutter_architecture_samples/app/router.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';

/// The only place that both registers dependencies and reads them back out.
void main() {
  configureDependencies();
  runApp(
    App(
      router: createRouter(characterRepository: getIt<CharacterRepository>()),
    ),
  );
}
