import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/features/characters/presentation/characters_routes.dart';
import 'package:go_router/go_router.dart';

/// Placeholder for the list screen. Stage 5 turns this into the real
/// bloc-driven list; for now one row proves navigation carries a parameter.
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: ListView(
        children: [
          for (final id in ['1', '2'])
            ListTile(
              title: Text('Character $id'),
              onTap: () => context.go(CharactersRoutes.detail(id)),
            ),
        ],
      ),
    );
  }
}
