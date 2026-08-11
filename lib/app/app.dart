import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/app/router.dart';
import 'package:flutter_architecture_samples/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

/// The root widget. It builds its own router so every `App()` — including one
/// per test — starts from a clean navigation stack.
class App extends StatelessWidget {
  App({super.key, GoRouter? router}) : _router = router ?? createRouter();

  final GoRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Characters',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
