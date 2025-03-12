import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project_pjam_2023/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('end-to-end testing', () {
    testWidgets('login and register', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Create a new account if you haven\'t already.'),
          findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);

      await tester.enterText(
          find.ancestor(
              of: find.text('Email'), matching: find.byType(TextField)),
          'test@example.com');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Password is required'), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsWidgets);
      expect(
          find.text('Already have an account? Log in here.'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Name is required'), findsOneWidget);

      await tester.enterText(
          find.ancestor(
              of: find.text('Name'), matching: find.byType(TextField)),
          'John');

      await tester.enterText(
          find.ancestor(
              of: find.text('Email'), matching: find.byType(TextField)),
          'test@example.com');

      await tester.enterText(
          find.ancestor(
              of: find.text('Password'), matching: find.byType(TextField)),
          'pass');

      await tester.enterText(
          find.ancestor(
              of: find.text('Confirm Password'),
              matching: find.byType(TextField)),
          'word');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Passwords do not match'), findsOneWidget);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsWidgets);
    });
  });
}
