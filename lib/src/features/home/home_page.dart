import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:project_pjam_2023/src/shared/components/feedback_history_card.dart';
import 'package:project_pjam_2023/src/shared/services/auth_service.dart';
import 'package:project_pjam_2023/src/shared/services/navigation_service.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/configs/constants.dart' as constants;
import 'home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthService().getUserRole() == constants.rolePatient) {
        context.read<HomeProvider>().fetchDataAsPatient();
      } else {
        context.read<HomeProvider>().fetchDataAsClinician();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                if (homeProvider.isLoading) {
                  return _buildLoadingScreen();
                } else {
                  return _buildWithData(homeProvider);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWelcomeText(),
        const SizedBox(height: 16),
        const CircularProgressIndicator(),
      ],
    );
  }

  Widget _buildWithData(HomeProvider homeProvider) {
    AuthService().getAuthToken();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildWelcomeText(),
        const SizedBox(height: 16),
        AuthService().getUserRole() == constants.rolePatient
            ? _buildImageSection(homeProvider.imagesPatient)
            : _buildImageSection(homeProvider.imagesClinician),
        const SizedBox(height: 16),
        AuthService().getUserRole() == constants.rolePatient
            ? _buildFeedbackSection(homeProvider.feedbackPatient)
            : _buildFeedbackSection(homeProvider.feedbackClinician),
      ],
    );
  }

  Widget _buildImageSection(List images) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Most Recent Images',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 18, color: Colors.grey),
                images.isEmpty
                    ? const Text('No activity found',
                        style: TextStyle(
                          fontSize: 16.0,
                        ))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemCount: images.length >= 6 ? 6 : images.length,
                        itemBuilder: (context, index) {
                          Uint8List imageBytes = const Base64Decoder()
                              .convert(images[index]!.image.data);
                          return InkWell(
                            onTap: () {
                              NavigationService().navigateToScreen(
                                  'Image Details',
                                  arguments: images[index]!.id);
                            },
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection(List feedback) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(32.0),
          ),
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Latest Feedback',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 18, color: Colors.grey),
                feedback.isEmpty
                    ? const Text('No activity found',
                        style: TextStyle(
                          fontSize: 16.0,
                        ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: feedback.length >= 5 ? 5 : feedback.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                NavigationService().navigateToScreen(
                                    'Image Details',
                                    arguments: feedback[index]!.imageID);
                              },
                              child: FeedbackHistoryCard(
                                  feedbackID: feedback[index]!.feedbackID,
                                  imageID: feedback[index]!.imageID,
                                  publishDate: feedback[index]!.createdAt,
                                  feedback: feedback[index]!.feedback));
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return RichText(
      textAlign: TextAlign.left,
      text: const TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: "Welcome back!",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
