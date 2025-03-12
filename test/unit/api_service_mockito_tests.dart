import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:project_pjam_2023/src/shared/configs/constants.dart'
    as constants;
import 'package:project_pjam_2023/src/shared/dtos/feedback_dto.dart';
import 'package:project_pjam_2023/src/shared/services/api_service.dart';

import 'api_service_mockito_tests.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('ApiService_GetImageFeedback', () {
    test('getImageFeedback - success', () async {
      final client = MockClient();
      ApiService apiService = ApiService(client: client);

      const imageId = 1;

      final expectedResponse = [
        {
          'feedback_id': 1,
          'clinician_id': 101,
          'clinician_name': 'Dr. Smith',
          'feedback': 'Good job!',
        },
      ];

      final url = "${constants.apiDomain}/feedback/image/$imageId";

      when(client.get(
        Uri.parse(url),
        headers: anyNamed("headers"),
      )).thenAnswer(
        (_) async =>
            http.Response(json.encode({'feedback': expectedResponse}), 200),
      );

      final result = await apiService.getImageFeedback(imageId);

      final expectedResult = expectedResponse
          .map((json) => FeedbackResponseDTO.fromJson(json))
          .toList();

      expect(result.length, equals(expectedResponse.length));

      for (int i = 0; i < result.length; i++) {
        expect(result[i].feedbackID, equals(expectedResult[i].feedbackID));
        expect(result[i].clinicianID, equals(expectedResult[i].clinicianID));
        expect(
            result[i].clinicianName, equals(expectedResult[i].clinicianName));
        expect(result[i].feedback, equals(expectedResult[i].feedback));
      }
    });

    test('get image feedback - failure (400)', () async {
      final client = MockClient();
      ApiService apiService = ApiService(client: client);

      const imageId = 456;
      const errorMessage = 'Invalid image ID';

      when(client.get(
              Uri.parse('${constants.apiDomain}/feedback/image/$imageId'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(errorMessage, 400));

      expect(() => apiService.getImageFeedback(imageId), throwsException);
    });
  });
}
