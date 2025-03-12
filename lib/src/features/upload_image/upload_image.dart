import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_pjam_2023/src/shared/extensions/string_extensions.dart';
import 'package:provider/provider.dart';

import '../../shared/components/drawer.dart';
import '../../shared/dtos/body_part_dto.dart';
import 'upload_image_provider.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UploadImageProvider>().fetchBodyParts();
      context.read<UploadImageProvider>().setImage(null);
    });
  }

  Future<void> _getImage(UploadImageProvider uploadImageProvider) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadImageProvider.setImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UploadImageProvider>(
          builder: (context, uploadImageProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async => await _getImage(uploadImageProvider),
                  child: Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: uploadImageProvider.image != null
                        ? Image.file(File(uploadImageProvider.image!.path),
                            fit: BoxFit.contain)
                        : const Center(child: Icon(Icons.add_a_photo)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "Body part",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<BodyPartResponseDTO>(
                      value: uploadImageProvider.selectedBodyPart,
                      elevation: 16,
                      onChanged: (BodyPartResponseDTO? newValue) {
                        setState(() {
                          uploadImageProvider.setSelectedBodyPart(newValue!);
                        });
                      },
                      items: uploadImageProvider.bodyParts
                          .map<DropdownMenuItem<BodyPartResponseDTO>>(
                              (BodyPartResponseDTO value) {
                        return DropdownMenuItem<BodyPartResponseDTO>(
                          value: value,
                          child: Text(value.name.capitalize()),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    uploadImageProvider
                        .submitImage(_descriptionController.text);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
