import 'package:flutter/material.dart';

import '../../../shared/dtos/register_dto.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/services/snackbar_service.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> register(RegisterDTO registerDTO) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (registerDTO.name.isEmpty) {
        throw Exception("Name is required");
      }
      if (registerDTO.email.isEmpty) {
        throw Exception("Email is required");
      }
      if (registerDTO.password.isEmpty) {
        throw Exception("Password is required");
      }
      if (registerDTO.confirmPassword.isEmpty) {
        throw Exception("Confirm password is required");
      }
      if (registerDTO.password != registerDTO.confirmPassword) {
        throw Exception("Passwords do not match");
      }
      await _apiService.register(registerDTO);
      _isLoading = false;
      SnackbarService.showSuccessSnackbar(
          "Account created successfully. Log in to continue.");
      NavigationService().replaceScreen('Login');
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
      notifyListeners();
    }
  }
}
