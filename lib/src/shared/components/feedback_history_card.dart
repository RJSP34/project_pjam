import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/navigation_service.dart';

class FeedbackHistoryCard extends StatefulWidget {
  final int feedbackID;
  final int imageID;
  final String feedback;
  final DateTime publishDate;

  const FeedbackHistoryCard({
    super.key,
    required this.feedbackID,
    required this.imageID,
    required this.publishDate,
    required this.feedback,
  });

  @override
  State<FeedbackHistoryCard> createState() => _FeedbackHistoryCardState();
}

class _FeedbackHistoryCardState extends State<FeedbackHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => NavigationService()
              .navigateToScreen('Image Details', arguments: widget.imageID),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat("MMM dd, y HH:mm").format(widget.publishDate),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.feedback,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }
}
