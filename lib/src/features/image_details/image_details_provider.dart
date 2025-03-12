import 'package:flutter/material.dart';

import '../../shared/configs/constants.dart';
import '../../shared/dtos/feedback_dto.dart';
import '../../shared/dtos/image_dto.dart';
import '../../shared/services/api_service.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/navigation_service.dart';
import '../../shared/services/snackbar_service.dart';

class ImageDetailsProvider extends ChangeNotifier {
  bool _isLoading = false;
  GetPsoriasisImageDTO? _image;
  List<FeedbackResponseDTO> _feedbackList = [];

  bool get isLoading => _isLoading;

  GetPsoriasisImageDTO? get image => _image;

  List<FeedbackResponseDTO> get feedbackList => _feedbackList;

  final ApiService _apiService = ApiService();

  final AuthService _authService = AuthService();

  Future<void> fetchImage(int imageID) async {
    _isLoading = true;
    notifyListeners();

    try {
      String role = _authService.getUserRole();

      final image = (role == rolePatient)
          ? await _apiService.getImage(imageID)
          : await _apiService.getImageAsClinician(imageID);
      _image = image;

      if (image != null) {
        final feedbackList = await _apiService.getImageFeedback(imageID);
        _feedbackList = feedbackList;
      }

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }

  Future<void> editDescription(int imageID, String description) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.updateImageDescription(imageID, description);
      _image = GetPsoriasisImageDTO(
        id: _image!.id,
        userID: _image!.userID,
        bodyPartID: _image!.bodyPartID,
        bodyPart: _image!.bodyPart,
        description: description,
        image: _image!.image,
        createdAt: _image!.createdAt,
      );
      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar("Description has been edited");
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  Future<void> deleteImage(int imageID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteImage(imageID);

      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar("Image deleted successfully");
      NavigationService().goBack();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  Future<void> submitFeedback(int imageID, String message) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.postSubmitFeedback(imageID, message);

      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar("Feedback submitted");
      await fetchImage(imageID);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  Future<void> editFeedback(int feedbackID, String message) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.editFeedback(feedbackID, message);

      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar("Feedback edited");
      NavigationService().goBack();
      await fetchImage(image!.id);
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  Future<void> deleteFeedback(int imageID) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteFeedback(imageID);

      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar("Feedback deleted");
      NavigationService().goBack();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }
}
