import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AuthService {
  static String? accessToken;

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
    required int role,
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
        "role": role,
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
}
