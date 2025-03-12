import '../models/image_model.dart';

class PsoriasisImageSubmitDTO {
  final int bodyPartID;
  final String description;
  final ImageData image;

  PsoriasisImageSubmitDTO({
    required this.bodyPartID,
    required this.description,
    required this.image,
  });
}

class GetPsoriasisImageDTO {
  final int id;
  final int userID;
  final int bodyPartID;
  final String bodyPart;
  final String description;
  final ImageData image;
  final DateTime createdAt;

  GetPsoriasisImageDTO({
    required this.id,
    required this.userID,
    required this.bodyPartID,
    required this.bodyPart,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory GetPsoriasisImageDTO.fromJson(Map<String, dynamic> json) {
    return GetPsoriasisImageDTO(
      id: json['id'],
      userID: json['user_id'],
      bodyPartID: json['body_part_id'],
      bodyPart: json['body_part'],
      description: json['description'],
      image: ImageData.fromJson(json['image']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class GetMyImageDTO {
  final int id;
  final int bodyPartID;
  final String bodyPart;
  final String description;
  final ImageData image;
  final DateTime createdAt;

  GetMyImageDTO({
    required this.id,
    required this.bodyPartID,
    required this.bodyPart,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory GetMyImageDTO.fromJson(Map<String, dynamic> json) {
    return GetMyImageDTO(
      id: json['id'],
      bodyPartID: json['body_part_id'],
      bodyPart: json['body_part'],
      description: json['description'],
      image: ImageData.fromJson(json['image']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class UpdateMyImageDescriptionDTO {
  final int id;
  final String description;

  UpdateMyImageDescriptionDTO({
    required this.id,
    required this.description,
  });
}

class GetMyImagesCliniciansDTO {
  final int id;
  final int bodyPartID;
  final String bodyPart;
  final String description;
  final ImageData image;
  final DateTime createdAt;
  final int patientID;
  final String patientName;
  final String patientEmail;

  GetMyImagesCliniciansDTO({
    required this.id,
    required this.bodyPartID,
    required this.bodyPart,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.patientID,
    required this.patientName,
    required this.patientEmail,
  });

  factory GetMyImagesCliniciansDTO.fromJson(Map<String, dynamic> json) {
    return GetMyImagesCliniciansDTO(
      id: json['id'],
      bodyPartID: json['body_part_id'],
      bodyPart: json['body_part'],
      description: json['description'],
      image: ImageData.fromJson(json['image']),
      createdAt: DateTime.parse(json['created_at']),
      patientID: json['patient_id'],
      patientName: json['patient_name'],
      patientEmail: json['patient_email'],
    );
  }
}
