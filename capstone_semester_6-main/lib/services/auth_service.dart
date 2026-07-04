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
    final normalizedUsername = normalizeUsername(username);

    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}/register",
      ),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "nama": nama,
        "username": normalizedUsername,
        "email": email,
        "password": password,
        "nohp": nohp,
        "alamat": alamat,
        "tgl_lahir": tglLahir,
        "role": role,
      }),
    );

    final responseBody = jsonDecode(response.body);

    return {
      "status": response.statusCode,
      "data": responseBody,
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

  static Future<Map<String, dynamic>> registerEvent({
    required String token,
    required int eventId,
    required Map<String, dynamic> data,
    required File scanWajahFile,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        "${ApiConfig.baseUrl}/event/register/$eventId",
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';

    // Add form fields
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add scan wajah image
    request.files.add(
      await http.MultipartFile.fromPath(
        'scan_wajah',
        scanWajahFile.path,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    return {
      "status": response.statusCode,
      "data": jsonDecode(responseBody),
    };
  }

  static Future<Map<String, dynamic>> uploadPayment({
    required String token,
    required int registrationId,
    required File paymentFile,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(
        "${ApiConfig.baseUrl}/event/payment/$registrationId",
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath(
        'bukti',
        paymentFile.path,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    return {
      "status": response.statusCode,
      "data": jsonDecode(responseBody),
    };
  }
}
