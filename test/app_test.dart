import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots into the characters screen', (tester) async {
    await tester.pumpWidget(App());

    expect(find.widgetWithText(AppBar, 'Characters'), findsOneWidget);
  });

  testWidgets('tapping a character opens the detail screen for that id', (
    tester,
  ) async {
    await tester.pumpWidget(App());

    await tester.tap(find.text('Character 2'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Character 2'), findsOneWidget);
  });

  testWidgets('the detail screen can be popped back to the list', (
    tester,
  ) async {
    await tester.pumpWidget(App());

    await tester.tap(find.text('Character 1'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Characters'), findsOneWidget);
  });
}
