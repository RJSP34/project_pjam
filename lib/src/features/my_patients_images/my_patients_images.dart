import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/components/patients_images_card.dart';
import 'my_patients_images_provider.dart';

class MyPatientsImages extends StatefulWidget {
  const MyPatientsImages({super.key});

  @override
  State<MyPatientsImages> createState() => _MyPatientsImagesState();
}

class _MyPatientsImagesState extends State<MyPatientsImages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientsImagesProvider>().fetchUserImages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patients' Images"),
      ),
      drawer: MyDrawer(),
      body: Consumer<PatientsImagesProvider>(
        builder: (context, patientsImagesProvider, child) {
          if (patientsImagesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (patientsImagesProvider.usersImages.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          } else {
            return ListView.builder(
              itemCount: patientsImagesProvider.usersImages.length,
              itemBuilder: (context, index) {
                final item = patientsImagesProvider.usersImages[index];
                return PatientImageCard(
                  id: item.id,
                  bodyPart: item.bodyPart,
                  description: item.description,
                  image: item.image,
                  publishDate: item.createdAt,
                  patientName: item.patientName,
                  patientEmail: item.patientEmail,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<PatientsImagesProvider>(context, listen: false)
              .fetchUserImages();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
