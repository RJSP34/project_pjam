import 'package:flutter/material.dart';

import '../../shared/dtos/image_dto.dart';
import '../../shared/services/api_service.dart';

class PatientsImagesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GetMyImagesCliniciansDTO> _usersImages = [];

  bool get isLoading => _isLoading;

  List<GetMyImagesCliniciansDTO> get usersImages => _usersImages;

  final ApiService _apiService = ApiService();

  Future<void> fetchUserImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final images = await _apiService.getAllImagesByClinician();
      _usersImages = List.from(images);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }
}
