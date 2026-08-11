import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/core/failure.dart';

/// What a screen shows instead of its content when the request failed.
///
/// It lives in `core/` because every screen that can fail needs the same thing,
/// and because a retry button that some screens have and others forget is how
/// an app ends up with dead ends.
class FailureView extends StatelessWidget {
  const FailureView({required this.failure, required this.onRetry, super.key});

  final Failure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(failure.message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
