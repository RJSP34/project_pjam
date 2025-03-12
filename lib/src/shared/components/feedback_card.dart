import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

class FeedbackCard extends StatefulWidget {
  final int feedbackID;
  final int clinicianID;
  final String clinicianName;
  final String feedback;
  final VoidCallback? onLongPress;

  const FeedbackCard({
    super.key,
    required this.feedbackID,
    required this.clinicianID,
    required this.clinicianName,
    required this.feedback,
    this.onLongPress,
  });

  @override
  State<FeedbackCard> createState() => _FeedbackCardState();
}

class _FeedbackCardState extends State<FeedbackCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          onLongPress: widget.onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    RandomAvatar(
                      widget.clinicianID.toString() + widget.clinicianName,
                      height: 50,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.clinicianName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.feedback,
                        style: const TextStyle(fontSize: 14),
                        maxLines: _isExpanded ? null : 3,
                        overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ));
  }
}
