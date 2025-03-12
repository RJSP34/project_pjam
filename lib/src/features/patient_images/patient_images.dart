import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/arguments/patient_images_arguments.dart';
import '../../shared/components/image_card.dart';
import 'patient_images_provider.dart';

class PatientImages extends StatefulWidget {
  const PatientImages({super.key});

  @override
  State<PatientImages> createState() => _PatientImagesState();
}

class _PatientImagesState extends State<PatientImages> {
  late PatientImagesArguments patientArgs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserImagesProvider>().setUserId(patientArgs.patientID);
      context.read<UserImagesProvider>().fetchUserImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    patientArgs =
        ModalRoute.of(context)?.settings.arguments as PatientImagesArguments? ??
            PatientImagesArguments(0, "");

    return Scaffold(
      appBar: AppBar(
        title: Text('${patientArgs.patientName}\'s Images'),
      ),
      body: Consumer<UserImagesProvider>(
        builder: (context, userImagesProvider, child) {
          if (userImagesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userImagesProvider.userImages.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            return ListView.builder(
              itemCount: userImagesProvider.userImages.length,
              itemBuilder: (context, index) {
                final item = userImagesProvider.userImages[index];
                return ImageCard(
                    id: item.id,
                    bodyPart: item.bodyPart,
                    description: item.description,
                    image: item.image,
                    publishDate: item.createdAt);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<UserImagesProvider>(context, listen: false)
              .fetchUserImages();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
