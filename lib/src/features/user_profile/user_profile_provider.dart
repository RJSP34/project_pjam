import 'package:flutter/material.dart';

import '../../shared/dtos/patient_clinician_dto.dart';
import '../../shared/dtos/user_dto.dart';
import '../../shared/services/api_service.dart';
import '../../shared/services/snackbar_service.dart';

class UserProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  ProfileDTO? _user;
  List<ClinicianDTO> _clinicians = [];
  List<ClinicianDTO> _allowedClinicians = [];

  bool get isLoading => _isLoading;

  ProfileDTO? get user => _user;

  List<ClinicianDTO> get clinicians => _clinicians;

  List<ClinicianDTO> get allowedClinicians => _allowedClinicians;

  final ApiService _apiService = ApiService();

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final profile = await _apiService.getProfile();
      _user = profile;

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllClinicians() async {
    _isLoading = true;
    notifyListeners();

    try {
      final clinicians = await _apiService.getClinicians();
      _clinicians = clinicians;

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllowedClinicians() async {
    _isLoading = true;
    notifyListeners();

    try {
      final allowedClinicians = await _apiService.getAllowedClinicians();
      _allowedClinicians = allowedClinicians;

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAllowedClinicians() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<PatientClinicianDTO> cliniciansList = _allowedClinicians
          .map((item) => PatientClinicianDTO(clinicianId: item.id))
          .toList();
      await _apiService.putAllowedClinicians(cliniciansList);

      _isLoading = false;
      notifyListeners();
      SnackbarService.showSuccessSnackbar(
          "Clinicians' permissions changed successfully");
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      SnackbarService.showErrorSnackbar(
          error.toString().split(': ').last.trim());
    }
  }

  void addOrRemoveAllowedClinician(ClinicianDTO clinician) {
    int index = _allowedClinicians.indexWhere((c) => c.id == clinician.id);
    index != -1 ? _allowedClinicians.removeAt(index) : _allowedClinicians.add(clinician);
    notifyListeners();
  }
}
