import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/extensions/string_extensions.dart';
import '../../shared/services/navigation_service.dart';
import '../models/image_model.dart';

class PatientImageCard extends StatelessWidget {
  final int id;
  final String bodyPart;
  final String description;
  final ImageData image;
  final DateTime publishDate;
  final String? user;
  final String? patientName;
  final String? patientEmail;

  const PatientImageCard({
    super.key,
    required this.id,
    required this.bodyPart,
    required this.description,
    required this.image,
    required this.publishDate,
    this.user,
    required this.patientName,
    required this.patientEmail,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = const Base64Decoder().convert(image.data);

    return Card(
        elevation: 8,
        margin: const EdgeInsets.all(8),
        child: InkWell(
          onTap: () => NavigationService()
              .navigateToScreen('Image Details', arguments: id),
          child: Row(
            children: [
              Image.memory(
                imageBytes,
                fit: BoxFit.scaleDown,
                height: 150,
                width: 150,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bodyPart.capitalize(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        patientName == null ? '' : patientName!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        patientEmail == null ? '' : patientEmail!,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat("MMM dd, y HH:mm").format(publishDate),
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
