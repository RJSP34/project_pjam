class FeedbackResponseDTO {
  final int feedbackID;
  final int clinicianID;
  final String clinicianName;
  final String feedback;

  FeedbackResponseDTO({
    required this.feedbackID,
    required this.clinicianID,
    required this.clinicianName,
    required this.feedback,
  });

  factory FeedbackResponseDTO.fromJson(Map<String, dynamic> json) {
    return FeedbackResponseDTO(
      feedbackID: json['feedback_id'],
      clinicianID: json['clinician_id'],
      clinicianName: json['clinician_name'],
      feedback: json['feedback'],
    );
  }
}

class ClinicianFeedbackDTO {
  final int feedbackID;
  final int imageID;
  final String feedback;
  final DateTime createdAt;

  ClinicianFeedbackDTO({
    required this.feedbackID,
    required this.imageID,
    required this.feedback,
    required this.createdAt,
  });

  factory ClinicianFeedbackDTO.fromJson(Map<String, dynamic> json) {
    return ClinicianFeedbackDTO(
      feedbackID: json['feedback_id'],
      imageID: json['image_id'],
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class FeedbackLastResponseDTO {
  final int feedbackID;
  final String feedback;
  final int imageID;
  final int clinicianID;
  final String clinicianName;
  final DateTime? createdAt;

  FeedbackLastResponseDTO({
    required this.feedbackID,
    required this.feedback,
    required this.imageID,
    required this.clinicianID,
    required this.clinicianName,
    this.createdAt,
  });

  factory FeedbackLastResponseDTO.fromJson(Map<String, dynamic> json) {
    return FeedbackLastResponseDTO(
      feedbackID: json['feedback_id'],
      feedback: json['feedback'],
      imageID: json['image_id'],
      clinicianID: json['clinician_id'],
      clinicianName: json['clinician_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
