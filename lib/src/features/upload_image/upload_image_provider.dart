import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/dtos/body_part_dto.dart';
import '../../shared/dtos/image_dto.dart';
import '../../shared/models/image_model.dart';
import '../../shared/services/api_service.dart';
import '../../shared/services/navigation_service.dart';
import '../../shared/services/snackbar_service.dart';

class UploadImageProvider extends ChangeNotifier {
  bool _isLoading = false;
  XFile? _image;
  List<BodyPartResponseDTO> _bodyParts = [];
  BodyPartResponseDTO _selectedBodyPart = BodyPartResponseDTO(id: 0, name: "0");

  bool get isLoading => _isLoading;

  XFile? get image => _image;

  List<BodyPartResponseDTO> get bodyParts => _bodyParts;

  BodyPartResponseDTO get selectedBodyPart => _selectedBodyPart;

  final ApiService _apiService = ApiService();

  Future<void> fetchBodyParts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final bodyParts = await _apiService.getBodyParts();
      _bodyParts = bodyParts;
      _bodyParts.sort((a, b) => a.name.compareTo(b.name));

      if (!_bodyParts.contains(_selectedBodyPart)) {
        _selectedBodyPart = _bodyParts.isNotEmpty
            ? _bodyParts.first
            : BodyPartResponseDTO(id: 0, name: "");
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  Future<void> submitImage(String description) async {
    try {
      String? fileExtension = image?.name.split('.').last;
      if (fileExtension == null ||
          !['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        throw Exception("Invalid file type");
      }

      String? mimeType = (fileExtension == 'png') ? 'image/png' : 'image/jpeg';
      List<int> imageBytes = File(image!.path).readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      ImageData imageData = ImageData(mime: mimeType, data: base64Image);
      await _apiService.postUploadImage(PsoriasisImageSubmitDTO(
          bodyPartID: _selectedBodyPart.id,
          description: description,
          image: imageData));
      SnackbarService.showSuccessSnackbar("Image has been submitted!");
      NavigationService().replaceScreen("My Images");
    } catch (error) {
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  void setSelectedBodyPart(BodyPartResponseDTO bodyPart) {
    _selectedBodyPart = bodyPart;
    notifyListeners();
  }

  void setImage(XFile? image) {
    _image = image;
    notifyListeners();
  }
}
