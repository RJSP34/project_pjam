import 'package:flutter/material.dart';

import '../../shared/dtos/image_dto.dart';
import '../../shared/services/api_service.dart';

class MyImagesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GetMyImageDTO> _userImages = [];

  bool get isLoading => _isLoading;
  List<GetMyImageDTO> get userImages => _userImages;

  final ApiService _apiService = ApiService();

  Future<void> fetchUserImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      final images = await _apiService.getMyImages();
      _userImages = List.from(images);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }
}
