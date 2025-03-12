import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:project_pjam_2023/src/shared/configs/constants.dart'
    as constants;
import 'package:project_pjam_2023/src/shared/dtos/feedback_dto.dart';
import 'package:project_pjam_2023/src/shared/dtos/login_dto.dart';
import 'package:project_pjam_2023/src/shared/services/api_service.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('ApiService_Login', () {
    test('login - success', () async {
      final client = MockClient((request) async {
        if (request.url.toString() == '${constants.apiDomain}/auth/login') {
          return http.Response(
            json.encode(
                {'token': 'your_mocked_token', 'message': 'login success'}),
            200,
          );
        }

        return http.Response('Not Found', 404);
      });

      ApiService apiService = ApiService(client: client);

      final loginDTO =
          LoginDTO(email: 'test@example.com', password: 'password');

      final result = await apiService.login(loginDTO);

      final expectedResponse = {
        'token': 'your_mocked_token',
        'message': 'login success',
      };

      expect(result, equals(expectedResponse));
    });
  });

  group('ApiService_GetImageFeedback', () {
    test('getImageFeedback - success', () async {
      final client = MockClient((request) async {
        if (request.url.toString() ==
            '${constants.apiDomain}/feedback/image/1') {
          return http.Response(
            json.encode({
              'feedback': [
                {
                  'feedback_id': 1,
                  'clinician_id': 101,
                  'clinician_name': 'Dr. Smith',
                  'feedback': 'Good job!',
                },
                // Add more feedback items as needed
              ],
            }),
            200,
          );
        }
        // Handle other requests if needed
        return http.Response('Not Found', 404);
      });

      ApiService apiService = ApiService(client: client);

      const imageId = 1;

      final result = await apiService.getImageFeedback(imageId);

      final expectedResponse = [
        FeedbackResponseDTO(
          feedbackID: 1,
          clinicianID: 101,
          clinicianName: 'Dr. Smith',
          feedback: 'Good job!',
        ),
      ];

      expect(result.length, equals(expectedResponse.length));

      for (int i = 0; i < result.length; i++) {
        expect(result[i].feedbackID, equals(expectedResponse[i].feedbackID));
        expect(result[i].clinicianID, equals(expectedResponse[i].clinicianID));
        expect(
            result[i].clinicianName, equals(expectedResponse[i].clinicianName));
        expect(result[i].feedback, equals(expectedResponse[i].feedback));
      }
    });
  });
}
