import 'package:flutter/material.dart';

import '../../../shared/dtos/login_dto.dart';
import '../../../shared/services/api_service.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/navigation_service.dart';
import '../../../shared/services/snackbar_service.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  Future<void> login(LoginDTO loginDTO) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (loginDTO.email.isEmpty) {
        throw Exception("Email is required");
      }
      if (loginDTO.password.isEmpty) {
        throw Exception("Password is required");
      }

      bool hasValidToken = await _authService.isAuthTokenValid();

      if (!hasValidToken) {
        Map<String, dynamic> responseBody = await _apiService.login(loginDTO);
        _authService.setAuthToken(responseBody["token"]);
      }

      _isLoading = false;
      SnackbarService.showSuccessSnackbar("Success! You're logged in.");
      NavigationService().replaceScreen('Home');
      notifyListeners();
    } catch (error) {
      _authService.clearAuthToken();
      _isLoading = false;
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
      notifyListeners();
    }
  }
}
