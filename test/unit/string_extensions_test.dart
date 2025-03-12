import 'package:flutter_test/flutter_test.dart';
import 'package:project_pjam_2023/src/shared/extensions/string_extensions.dart';

void main() {
  group('StringExtensions', () {
    test('capitalize should capitalize the first letter', () {
      const lowercaseString = 'hello';
      const emptyString = '';

      final capitalizedLowercase = lowercaseString.capitalize();
      final capitalizedEmptyString = emptyString.capitalize();

      expect(capitalizedLowercase, 'Hello');
      expect(capitalizedEmptyString, '');
    });
  });
}
