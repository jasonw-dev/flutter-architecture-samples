import 'package:flutter/material.dart';

/// Placeholder for the list screen. Stage 5 turns this into the real
/// bloc-driven list; stage 2 gives it a route.
class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Characters')),
      body: const Center(child: Text('Nothing here yet.')),
    );
  }
}
