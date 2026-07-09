import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AuthService {
  static String? accessToken;

  static String normalizeUsername(String value) {
    return value.trim().toLowerCase();
  }

  static String buildErrorMessage(Map<String, dynamic> data) {
    final msg = data['msg']?.toString() ?? '';

    if (msg.contains('Duplicate entry') || msg.contains('username')) {
      return 'Username sudah dipakai. Silakan pilih username lain.';
    }

    return msg.isNotEmpty ? msg : 'Registrasi gagal.';
  }

  static Future<Map<String, dynamic>> register({
  required String nama,
  required String username,
  required String email,
  required String password,
  required String nohp,
  required String alamat,
  required String tglLahir,
  required int role,
}) async {

  final response = await http.post(
    Uri.parse(
      "${ApiConfig.baseUrl}/register",
    ),
    headers: {
      "Content-Type":
          "application/json"
    },
    body: jsonEncode({
      "nama": nama,
      "username": username,
      "email": email,
      "password": password,
      "nohp": nohp,
      "alamat": alamat,
      "tgl_lahir": tglLahir,
      "role": role,
    }),
  );

  return {
    "status":
        response.statusCode,
    "data":
        jsonDecode(response.body),
  };
}

static Future<Map<String, dynamic>>
    verifyOtp({
  required String email,
  required String otp,
}) async {

  final response = await http.post(
    Uri.parse(
      "${ApiConfig.baseUrl}/verify-otp",
    ),
    headers: {
      "Content-Type":
          "application/json",
    },
    body: jsonEncode({
      "email": email,
      "otp": otp,
    }),
  );

  return {
    "status":
        response.statusCode,
    "data":
        jsonDecode(response.body),
  };
}

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}/login",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 && responseBody is Map<String, dynamic>) {
      accessToken = responseBody['access_token'] as String?;
    }

    return {
      "status": response.statusCode,
      "data": responseBody,
    };
  }

  static Future<Map<String, dynamic>> getMe() async {
    final token = accessToken;
    if (token == null || token.isEmpty) return {"status": 401, "data": {"msg": "No token"}};

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}/me"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {"msg": response.body};
    }

    return {"status": response.statusCode, "data": body};
  }
}
