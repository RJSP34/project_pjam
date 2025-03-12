import 'dart:convert';

import 'package:http/http.dart' as http;

import '../configs/constants.dart' as constants;
import '../dtos/body_part_dto.dart';
import '../dtos/feedback_dto.dart';
import '../dtos/image_dto.dart';
import '../dtos/login_dto.dart';
import '../dtos/patient_clinician_dto.dart';
import '../dtos/register_dto.dart';
import '../dtos/user_dto.dart';
import 'auth_service.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> login(LoginDTO loginDTO) async {
    final url = "${constants.apiDomain}/auth/login";
    final body = {'email': loginDTO.email, 'password': loginDTO.password};

    try {
      final response = await client.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> register(RegisterDTO registerDTO) async {
    final url = "${constants.apiDomain}/auth/register";
    final body = {
      'name': registerDTO.name,
      'email': registerDTO.email,
      'password': registerDTO.password
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> logout() async {
    final url = "${constants.apiDomain}/auth/logout";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: headers,
      );
      AuthService().clearAuthToken();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<GetMyImageDTO>> getMyImages() async {
    final url = "${constants.apiDomain}/user/images";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["images"] == null) return [];
        final List<GetMyImageDTO> images = List.from(jsonResponse["images"])
            .map((json) => GetMyImageDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return images;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<GetPsoriasisImageDTO?> getImage(int imageId) async {
    final url = "${constants.apiDomain}/user/images/$imageId";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["image"] == null) return null;
        final image = GetPsoriasisImageDTO.fromJson(jsonResponse["image"]);
        return image;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<GetMyImagesCliniciansDTO?>> getAllImagesByClinician() async {
    final url = "${constants.apiDomain}/clinicians/images";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["images"] == null) return [];
        final List<dynamic> imagesList = List.from(jsonResponse["images"]);

        final List<GetMyImagesCliniciansDTO> images = imagesList
            .map((json) => GetMyImagesCliniciansDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return images;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ClinicianFeedbackDTO?>> getFeedbackByClinician() async {
    final url = "${constants.apiDomain}/clinicians/myfeedback";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["feedback"] == null) return [];
        final List<dynamic> imagesList = List.from(jsonResponse["feedback"]);

        final List<ClinicianFeedbackDTO> cliniciansFeedback = imagesList
            .map((json) => ClinicianFeedbackDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return cliniciansFeedback;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<GetPsoriasisImageDTO?> getImageAsClinician(int imageId) async {
    final url = "${constants.apiDomain}/clinicians/image/$imageId";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["image"] == null) return null;
        final image = GetPsoriasisImageDTO.fromJson(jsonResponse["image"]);
        return image;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<GetMyImageDTO>> getAllPatientsImages(int patientId) async {
    final url = "${constants.apiDomain}/clinicians/patient/$patientId";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["images"] == null) return [];
        final List<dynamic> imagesList = List.from(jsonResponse["images"]);

        final List<GetMyImageDTO> images = imagesList
            .map((json) => GetMyImageDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return images;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<FeedbackResponseDTO>> getImageFeedback(int imageId) async {
    final url = "${constants.apiDomain}/feedback/image/$imageId";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["feedback"] == null) return [];
        final List<dynamic> jsonFeedbackList =
            List.from(jsonResponse["feedback"]);

        final List<FeedbackResponseDTO> feedbackList = jsonFeedbackList
            .map((json) => FeedbackResponseDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return feedbackList;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<AllowedPatientsClinicianDTO>> getAllAuthorizedPatients() async {
    final url = "${constants.apiDomain}/clinicians/patient";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["patients"] == null) return [];
        final List<dynamic> jsonFeedbackList =
            List.from(jsonResponse["patients"]);

        final List<AllowedPatientsClinicianDTO> allowedCliniciansList =
            jsonFeedbackList
                .map((json) => AllowedPatientsClinicianDTO.fromJson(json))
                .toList()
                .reversed
                .toList();
        return allowedCliniciansList;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> updateImageDescription(int imageID, String description) async {
    final url = "${constants.apiDomain}/user/images";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };
    var body = {'id': imageID.toString(), 'description': description};

    try {
      final response = await client.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse["message"];
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> deleteImage(int imageID) async {
    final url = "${constants.apiDomain}/user/images/$imageID";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse["message"];
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<BodyPartResponseDTO>> getBodyParts() async {
    final url = "${constants.apiDomain}/body_parts";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["body_parts"] == null) return [];
        final List<dynamic> jsonBodyPartsList =
            List.from(jsonResponse["body_parts"]);

        final List<BodyPartResponseDTO> bodyPartsList = jsonBodyPartsList
            .map((json) => BodyPartResponseDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return bodyPartsList;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<FeedbackLastResponseDTO>> getLastFeedBack() async {
    final url = "${constants.apiDomain}/feedback/last";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["feedbacks"] == null) return [];
        final List<dynamic> jsonBodyPartsList =
            List.from(jsonResponse["feedbacks"]);

        final List<FeedbackLastResponseDTO> feedbackResponseDTO =
            jsonBodyPartsList
                .map((json) => FeedbackLastResponseDTO.fromJson(json))
                .toList()
                .reversed
                .toList();
        return feedbackResponseDTO;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> postSubmitFeedback(
      int imageID, String message) async {
    final url = "${constants.apiDomain}/clinicians/feedback";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
      'Content-Type': 'application/json'
    };
    final body = {
      'image_id': imageID,
      'feedback': message,
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<Map<String, dynamic>> postUploadImage(
      PsoriasisImageSubmitDTO image) async {
    final url = "${constants.apiDomain}/user/images/submit";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
      'Content-Type': 'application/json'
    };
    final body = {
      'description': image.description,
      'body_part_id': image.bodyPartID,
      'image': {'mime': image.image.mime, 'data': image.image.data}
    };

    try {
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<ProfileDTO?> getProfile() async {
    final url = "${constants.apiDomain}/profile";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
      'Content-Type': 'application/json'
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["profile"] == null) return null;
        final profile = ProfileDTO.fromJson(jsonResponse["profile"]);
        return profile;
      } else if (response.statusCode == 400) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> editFeedback(int feedbackID, String feedback) async {
    final url = "${constants.apiDomain}/clinicians/feedback";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
      'Content-Type': 'application/json'
    };
    final body = {'feedback_id': feedbackID, 'feedback': feedback};

    try {
      final response = await client.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse["message"];
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<String> deleteFeedback(int feedbackID) async {
    final url = "${constants.apiDomain}/clinicians/feedback/$feedbackID";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}'
    };

    try {
      final response = await client.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse["message"];
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ClinicianDTO>> getClinicians() async {
    final url = "${constants.apiDomain}/user/clinicians";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["clinicians"] == null) return [];
        final List<dynamic> jsonCliniciansList =
            List.from(jsonResponse["clinicians"]);

        final List<ClinicianDTO> cliniciansList = jsonCliniciansList
            .map((json) => ClinicianDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return cliniciansList;
      } else if (response.statusCode == 404) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<List<ClinicianDTO>> getAllowedClinicians() async {
    final url = "${constants.apiDomain}/user/allowed_clinicians";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
    };

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse["clinicians"] == null) return [];
        final List<dynamic> jsonCliniciansList =
            List.from(jsonResponse["clinicians"]);

        final List<ClinicianDTO> cliniciansList = jsonCliniciansList
            .map((json) => ClinicianDTO.fromJson(json))
            .toList()
            .reversed
            .toList();
        return cliniciansList;
      } else if (response.statusCode == 404) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> putAllowedClinicians(
      List<PatientClinicianDTO> clinicianIDsList) async {
    final url = "${constants.apiDomain}/user/clinicians";
    final headers = {
      'Authorization': 'Bearer ${await AuthService().getAuthToken()}',
      'Content-Type': 'application/json'
    };
    final body = clinicianIDsList
        .map((clinicianDTO) => {'clinician_id': clinicianDTO.clinicianId})
        .toList();

    try {
      final response = await client.put(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 404) {
        final errorMessage = _extractErrorMessage(response.body);
        throw Exception(errorMessage);
      } else {
        throw Exception('Error: Unexpected status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  String _extractErrorMessage(String responseBody) {
    final jsonResponse = json.decode(responseBody);
    return jsonResponse['error'] ?? jsonResponse['message'] ?? 'Unknown error';
  }
}
