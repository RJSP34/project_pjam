import 'package:flutter/material.dart';

import '../dtos/user_dto.dart';

class AllowedClinicianCard extends StatelessWidget {
  final ClinicianDTO clinician;
  final VoidCallback? onDelete;

  const AllowedClinicianCard({
    super.key,
    required this.clinician,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              clinician.name,
              style: const TextStyle(fontSize: 18),
            ),
            InkWell(
              onLongPress: onDelete,
              child: const Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}