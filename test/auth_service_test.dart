import 'package:capstone/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService helpers', () {
    test('normalizes username by trimming and lowercasing', () {
      expect(
        AuthService.normalizeUsername('  Budi123  '),
        'budi123',
      );
    });

    test('builds a friendly message for duplicate username errors', () {
      final message = AuthService.buildErrorMessage({
        'msg': 'Duplicate entry username',
      });

      expect(message, contains('Username'));
    });
  });
}
