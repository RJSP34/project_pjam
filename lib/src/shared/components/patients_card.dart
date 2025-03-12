import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../shared/arguments/patient_images_arguments.dart';
import '../../shared/services/navigation_service.dart';

class PatientsCard extends StatefulWidget {
  final int patientID;
  final int clinicianID;
  final String patientName;
  final String patientEmail;

  const PatientsCard({
    super.key,
    required this.patientID,
    required this.clinicianID,
    required this.patientName,
    required this.patientEmail,
  });

  @override
  State<PatientsCard> createState() => _PatientsCardState();
}

class _PatientsCardState extends State<PatientsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () {
            NavigationService().navigateToScreen("Patient Images",
                arguments: PatientImagesArguments(
                    widget.patientID, widget.patientName));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 8),
                    RandomAvatar(
                      widget.clinicianID.toString() + widget.patientName,
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
                        widget.patientName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.patientEmail,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
