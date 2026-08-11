import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/app/app.dart';
import 'package:flutter_architecture_samples/app/router.dart';
import 'package:flutter_architecture_samples/features/characters/domain/character_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/characters/fake_character_repository.dart';

/// The whole app on top of a fake repository: real router, real blocs, real
/// widgets, no network. Nothing here knows that `Dio` exists.
void main() {
  Widget appWith(CharacterRepository repository) =>
      App(router: createRouter(characterRepository: repository));

  testWidgets('the list screen shows what the repository returned', (
    tester,
  ) async {
    await tester.pumpWidget(appWith(FakeCharacterRepository()));
    await tester.pump();

    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Morty Smith'), findsOneWidget);
  });

  testWidgets('tapping a character opens its detail screen', (tester) async {
    await tester.pumpWidget(appWith(FakeCharacterRepository()));
    await tester.pump();

    await tester.tap(find.text('Morty Smith'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Rick Sanchez'), findsOneWidget);
    expect(find.text('Earth (C-137)'), findsOneWidget);
  });

  testWidgets('the detail screen can be popped back to the list', (
    tester,
  ) async {
    await tester.pumpWidget(appWith(FakeCharacterRepository()));
    await tester.pump();

    await tester.tap(find.text('Morty Smith'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Characters'), findsOneWidget);
  });

  testWidgets('a failed load offers a retry instead of an empty screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      appWith(FakeCharacterRepository(list: offline)),
    );
    await tester.pump();

    expect(find.textContaining("Can't reach the server"), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Try again'), findsOneWidget);
  });
}
