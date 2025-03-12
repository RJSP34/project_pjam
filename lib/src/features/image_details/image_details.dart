import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/components/feedback_card.dart';
import '../../shared/configs/constants.dart' as constants;
import '../../shared/dtos/feedback_dto.dart';
import '../../shared/dtos/image_dto.dart';
import '../../shared/extensions/string_extensions.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/navigation_service.dart';
import 'image_details_provider.dart';

class ImageDetails extends StatefulWidget {
  const ImageDetails({super.key});

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _newFeedbackController = TextEditingController();
  final TextEditingController _editFeedbackController = TextEditingController();
  late int imageID;

  @override
  void initState() {
    super.initState();

    _editFeedbackController.text = '';
    _descriptionController.text = '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ImageDetailsProvider>().fetchImage(imageID);
    });
  }

  @override
  Widget build(BuildContext context) {
    imageID = ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Details"),
        actions: AuthService().getUserRole() == constants.rolePatient
            ? buildPopupMenu()
            : [],
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Consumer<ImageDetailsProvider>(
          builder: (context, imageDetailsProvider, child) {
            if (imageDetailsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (imageDetailsProvider.image == null) {
              return const Center(
                child: Text("No data found"),
              );
            } else {
              return buildImageDetails();
            }
          },
        ),
      ),
    );
  }

  Widget buildImageDetails() {
    ImageDetailsProvider imageDetailsProvider =
        context.read<ImageDetailsProvider>();
    GetPsoriasisImageDTO image = imageDetailsProvider.image!;
    List<FeedbackResponseDTO> feedbackList = imageDetailsProvider.feedbackList;
    Uint8List imageBytes = const Base64Decoder().convert(image.image.data);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Published on ${DateFormat("MMM dd, y HH:mm").format(image.createdAt)}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Image.memory(
            imageBytes,
            fit: BoxFit.fill,
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, color: Colors.black),
              children: [
                const TextSpan(
                  text: "Body part: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: image.bodyPart.capitalize(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
                text: "Description:",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Text(
            image.description,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(
            height: 32.0,
          ),
          RichText(
            text: const TextSpan(
                text: "Clinical Feedback",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
          ),
          if (AuthService().getUserRole() == constants.roleClinician)
            buildFeedbackInputSection(imageDetailsProvider),
          if (feedbackList.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedbackList.length,
              itemBuilder: (context, index) {
                FeedbackResponseDTO feedback = feedbackList[index];
                return FeedbackCard(
                  feedbackID: feedback.feedbackID,
                  feedback: feedback.feedback,
                  clinicianID: feedback.clinicianID,
                  clinicianName: feedback.clinicianName,
                  onLongPress: () {
                    if (feedback.clinicianID == AuthService().getUserID()) {
                      _showFeedbackPopupMenu(
                          context, feedback.feedbackID, feedback.feedback);
                    }
                  },
                );
              },
            )
          else
            const Text("No feedback available."),
        ],
      ),
    );
  }

  List<Widget> buildPopupMenu() {
    return [
      PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return buildEditModalSheet(context);
              },
            );
          } else if (value == 'delete') {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return buildDeleteModalSheet(context);
                });
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Description'),
            ),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Image'),
            ),
          ),
        ],
      )
    ];
  }

  Widget buildEditModalSheet(BuildContext context) {
    ImageDetailsProvider imageDetailsProvider =
        context.read<ImageDetailsProvider>();

    if (_descriptionController.text.isEmpty) {
      _descriptionController.text =
          imageDetailsProvider.image?.description ?? '';
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 32.0,
            right: 32.0,
            top: 16.0),
        child: Column(
          children: [
            const Text(
              'Edit Description',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String newDescription = _descriptionController.text;
                    imageDetailsProvider.editDescription(
                        imageID, newDescription);
                    NavigationService().goBack();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteModalSheet(BuildContext context) {
    ImageDetailsProvider imageDetailsProvider =
        context.read<ImageDetailsProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 32.0,
            right: 32.0,
            top: 16.0),
        child: Column(
          children: [
            const Text(
              'Warning!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
                "The image will be permanently deleted. You will also lose all "
                "the feedback you have received. Are you sure you "
                "want to proceed?"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _descriptionController.text;
                    imageDetailsProvider.deleteImage(imageID);

                    NavigationService().goBack();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildFeedbackInputSection(ImageDetailsProvider imageDetailsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _newFeedbackController,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Give your feedback',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            imageDetailsProvider.submitFeedback(
                imageID, _newFeedbackController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  void _showFeedbackPopupMenu(
      BuildContext context, int feedbackID, String oldFeedback) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      const Rect.fromLTRB(0, 0, 0, 0),
      Offset.zero & overlay.size,
    );

    ImageDetailsProvider imageDetailsProvider =
        context.read<ImageDetailsProvider>();

    showMenu(
      context: context,
      position: position,
      items:
          buildFeedbackPopupMenu(imageDetailsProvider, feedbackID, oldFeedback),
    );
  }

  List<PopupMenuEntry<String>> buildFeedbackPopupMenu(
      ImageDetailsProvider imageDetailsProvider,
      int feedbackID,
      String oldFeedback) {
    return [
      PopupMenuItem<String>(
        value: 'edit',
        child: ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Edit'),
          onTap: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return buildEditFeedbackModalSheet(
                    imageDetailsProvider, feedbackID, oldFeedback);
              },
            );
          },
        ),
      ),
      PopupMenuItem<String>(
        value: 'delete',
        child: ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Delete'),
          onTap: () {
            Navigator.of(context).pop(); // Close the popup menu
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return buildDeleteFeedbackModalSheet(
                    imageDetailsProvider, feedbackID);
              },
            );
          },
        ),
      ),
    ];
  }

  Widget buildEditFeedbackModalSheet(ImageDetailsProvider imageDetailsProvider,
      int feedbackID, String oldFeedback) {
    if (_editFeedbackController.text.isEmpty) {
      _editFeedbackController.text = oldFeedback;
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 32.0,
            right: 32.0,
            top: 16.0),
        child: Column(
          children: [
            const Text(
              'Edit Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _editFeedbackController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Feedback',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String editFeedback = _editFeedbackController.text;
                    imageDetailsProvider.editFeedback(feedbackID, editFeedback);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildDeleteFeedbackModalSheet(
      ImageDetailsProvider imageDetailsProvider, int feedbackID) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 32.0,
            right: 32.0,
            top: 16.0),
        child: Column(
          children: [
            const Text(
              'Warning!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
                "Your feedback will be removed permanently. Are you sure you "
                "want to proceed?"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _editFeedbackController.text;
                    imageDetailsProvider.deleteFeedback(feedbackID);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Confirm'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
