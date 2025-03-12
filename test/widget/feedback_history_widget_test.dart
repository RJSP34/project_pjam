import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project_pjam_2023/src/features/feedback_history/feedback_history.dart';
import 'package:project_pjam_2023/src/features/feedback_history/feedback_history_provider.dart';
import 'package:project_pjam_2023/src/shared/components/feedback_history_card.dart';
import 'package:project_pjam_2023/src/shared/dtos/feedback_dto.dart';
import 'package:provider/provider.dart';

import 'feedback_history_widget_test.mocks.dart';

@GenerateMocks([FeedbackHistoryProvider])
void main() {
  group('FeedbackHistory Widget Test', () {
    testWidgets('Renders FeedbackHistory widget', (WidgetTester tester) async {
      final mockProvider = MockFeedbackHistoryProvider();
      when(mockProvider.isLoading).thenReturn(false);
      when(mockProvider.clinicianFeedback).thenReturn([
        ClinicianFeedbackDTO(
          feedbackID: 1,
          imageID: 101,
          feedback: 'Great work!',
          createdAt: DateTime.now(),
        ),
        ClinicianFeedbackDTO(
          feedbackID: 2,
          imageID: 102,
          feedback: 'Keep it up!',
          createdAt: DateTime.now(),
        ),
      ]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeedbackHistoryProvider>.value(
            value: mockProvider,
            child: const FeedbackHistory(),
          ),
        ),
      );

      expect(find.text('Feedback History'), findsOneWidget);

      expect(find.text('Great work!'), findsOneWidget);

      expect(find.byType(CircularProgressIndicator), findsNothing);

      expect(find.byType(FeedbackHistoryCard), findsWidgets);

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Renders loading state', (WidgetTester tester) async {
      final mockProvider = MockFeedbackHistoryProvider();
      when(mockProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<FeedbackHistoryProvider>.value(
            value: mockProvider,
            child: const FeedbackHistory(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
