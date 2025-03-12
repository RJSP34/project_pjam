import 'package:flutter/material.dart';

import '../../shared/dtos/image_dto.dart';
import '../../shared/services/api_service.dart';

class UserImagesProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GetMyImageDTO> _userImages = [];
  int? _userID;

  bool get isLoading => _isLoading;

  List<GetMyImageDTO> get userImages => _userImages;

  int? get userID => _userID;

  final ApiService _apiService = ApiService();

  Future<void> fetchUserImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      if (userID != null) {
        final images = await _apiService.getAllPatientsImages(userID!);
        _userImages = images;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }

  void setUserId(int userID) {
    _userID = userID;
  }
}
