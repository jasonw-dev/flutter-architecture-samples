import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/core/theme/app_theme.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Characters',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const CharactersPage(),
    );
  }
}
