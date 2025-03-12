import 'package:flutter/material.dart';

import '../../shared/services/navigation_service.dart';

class ErrorPage extends StatelessWidget {
  final String? title;
  final String? message;

  const ErrorPage({super.key, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "Error"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              message ?? "Oops! Something went wrong.",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate back to a known, safe state
                NavigationService().popToFirst();
              },
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
