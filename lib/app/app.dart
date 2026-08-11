import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

/// The root widget. The router is passed in rather than built here, so a test
/// can start the real app on top of fake repositories.
class App extends StatelessWidget {
  const App({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Characters',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
