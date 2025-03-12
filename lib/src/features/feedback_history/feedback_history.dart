import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/components/feedback_history_card.dart';
import 'feedback_history_provider.dart';

class FeedbackHistory extends StatefulWidget {
  const FeedbackHistory({super.key});

  @override
  State<FeedbackHistory> createState() => _FeedbackHistoryState();
}

class _FeedbackHistoryState extends State<FeedbackHistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackHistoryProvider>().fetchFeedbackHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback History"),
      ),
      drawer: MyDrawer(),
      body: Consumer<FeedbackHistoryProvider>(
        builder: (context, feedbackHistoryProvider, child) {
          if (feedbackHistoryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (feedbackHistoryProvider.clinicianFeedback.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            return ListView.builder(
              itemCount: feedbackHistoryProvider.clinicianFeedback.length,
              itemBuilder: (context, index) {
                final item = feedbackHistoryProvider.clinicianFeedback[index];
                return FeedbackHistoryCard(
                  feedbackID: item.feedbackID,
                  imageID: item.imageID,
                  publishDate: item.createdAt,
                  feedback: item.feedback,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<FeedbackHistoryProvider>(context, listen: false)
              .fetchFeedbackHistory();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
