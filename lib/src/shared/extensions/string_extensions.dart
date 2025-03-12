import 'dart:math';

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String generateRandomString({int? minLength, int? maxLength}) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    minLength ??= 1;
    maxLength ??= 12;

    minLength = max(1, minLength);
    maxLength = max(minLength, maxLength);

    final length = minLength + random.nextInt(maxLength - minLength + 1);

    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }
}
