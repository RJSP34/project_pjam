import 'package:flutter/material.dart';

import '../../shared/configs/constants.dart';
import '../../shared/dtos/feedback_dto.dart';
import '../../shared/dtos/image_dto.dart';
import '../../shared/services/api_service.dart';
import '../../shared/services/auth_service.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<GetMyImageDTO?> _imagesPatient = [];
  List<FeedbackLastResponseDTO> _feedbackPatient = [];
  List<GetMyImagesCliniciansDTO?> _imagesClinician = [];
  List<ClinicianFeedbackDTO?> _feedbackClinician = [];

  bool get isLoading => _isLoading;

  List<GetMyImageDTO?> get imagesPatient => _imagesPatient;

  List<FeedbackLastResponseDTO> get feedbackPatient => _feedbackPatient;

  List<GetMyImagesCliniciansDTO?> get imagesClinician => _imagesClinician;

  List<ClinicianFeedbackDTO?> get feedbackClinician => _feedbackClinician;

  final ApiService _apiService = ApiService();

  final AuthService _authService = AuthService();

  Future<void> fetchImagesAndFeedback() async {
    _isLoading = true;
    notifyListeners();

    try {
      String role = _authService.getUserRole();
      if (role == rolePatient) {
        List<GetMyImageDTO> image = await _apiService.getMyImages();
        _imagesPatient = image;
        final feedbackList = await _apiService.getLastFeedBack();
        _feedbackPatient = feedbackList;
      } else {
        List<GetMyImagesCliniciansDTO?> image =
            await _apiService.getAllImagesByClinician();
        _imagesClinician = image;
        final feedbackList = await _apiService.getFeedbackByClinician();
        _feedbackClinician = feedbackList;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDataAsPatient() async {
    _isLoading = true;
    notifyListeners();

    try {
      String role = _authService.getUserRole();
      if (role == rolePatient) {
        List<GetMyImageDTO> image = await _apiService.getMyImages();
        _imagesPatient = image;

        final feedbackList = await _apiService.getLastFeedBack();
        _feedbackPatient = feedbackList;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDataAsClinician() async {
    _isLoading = true;
    notifyListeners();

    try {
      String role = _authService.getUserRole();
      if (role == roleClinician) {
        List<GetMyImagesCliniciansDTO?> image =
            await _apiService.getAllImagesByClinician();
        _imagesClinician = image;

        final feedbackList = await _apiService.getFeedbackByClinician();
        _feedbackClinician = feedbackList;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }
}
