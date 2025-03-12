import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project_pjam_2023/src/features/authentication/login/login_page.dart';
import 'package:project_pjam_2023/src/features/authentication/login/login_provider.dart';
import 'package:provider/provider.dart';

import 'login_page_widget_test.mocks.dart';

@GenerateMocks([LoginProvider])
void main() {
  group('LoginPage Widget Test', () {
    testWidgets('Renders LoginPage widget', (WidgetTester tester) async {
      final mockProvider = MockLoginProvider();
      when(mockProvider.isLoading).thenReturn(false);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LoginProvider>.value(
            value: mockProvider,
            child: const LoginPage(),
          ),
        ),
      );

      expect(find.text('Login'), findsWidgets);

      expect(find.byType(TextField), findsNWidgets(2));

      expect(find.byType(ElevatedButton), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Renders loading state', (WidgetTester tester) async {
      final mockProvider = MockLoginProvider();
      when(mockProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<LoginProvider>.value(
            value: mockProvider,
            child: const LoginPage(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
