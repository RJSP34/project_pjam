import 'package:flutter/material.dart';

import '../../shared/dtos/feedback_dto.dart';
import '../../shared/services/api_service.dart';

class FeedbackHistoryProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<ClinicianFeedbackDTO> _clinicianFeedback = [];

  bool get isLoading => _isLoading;
  List<ClinicianFeedbackDTO> get clinicianFeedback => _clinicianFeedback;

  final ApiService _apiService = ApiService();

  Future<void> fetchFeedbackHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final feedback = await _apiService.getFeedbackByClinician();
      _clinicianFeedback = List.from(feedback);

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception(error);
    }
  }
}
