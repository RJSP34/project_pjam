import 'package:flutter/material.dart';

import '../../shared/dtos/patient_clinician_dto.dart';
import '../../shared/services/api_service.dart';

class MyPatientsProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<AllowedPatientsClinicianDTO> _patients = [];

  bool get isLoading => _isLoading;

  List<AllowedPatientsClinicianDTO> get patients => _patients;

  final ApiService _apiService = ApiService();

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final images = await _apiService.getAllAuthorizedPatients();
      _patients = List.from(images);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }
}
