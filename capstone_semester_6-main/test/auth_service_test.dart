import 'package:capstone/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('normalizeUsername trims and lowercases input', () {
    expect(AuthService.normalizeUsername(' ARKAN '), 'arkan');
    expect(AuthService.normalizeUsername('ArKan123'), 'arkan123');
  });

  test('buildErrorMessage returns friendly duplicate username message', () {
    expect(
      AuthService.buildErrorMessage({
        'msg': "(1062, \"Duplicate entry 'ARKAN' for key 'username'\")",
      }),
      'Username sudah dipakai. Silakan pilih username lain.',
    );
  });
}
