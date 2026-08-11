import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots into the characters screen', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Characters'), findsOneWidget);
  });
}
