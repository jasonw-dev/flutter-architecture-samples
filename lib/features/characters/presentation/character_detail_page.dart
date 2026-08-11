import 'package:flutter/material.dart';

/// Placeholder for the detail screen. It takes the id from the path; whether
/// it refetches or receives the character itself is decided in stage 6.
class CharacterDetailPage extends StatelessWidget {
  const CharacterDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Character $id')),
      body: const Center(child: Text('Nothing here yet.')),
    );
  }
}
