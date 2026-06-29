import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/profile_model.dart';
import 'auth_service.dart';

class ProfileService {
  static Future<ProfileModel> fetchProfile() async {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final message = body['msg'] ?? 'Gagal memuat profil';
      throw Exception(message);
    }

    return ProfileModel.fromJson(body as Map<String, dynamic>);
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String email,
    required String alamat,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/profile');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['nama'] = nama;
    request.fields['email'] = email;
    request.fields['alamat'] = alamat;

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'foto_profile',
          imageBytes,
          filename: imageName,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final responseBody = jsonDecode(response.body);
    return {
      'status': response.statusCode,
      'data': responseBody,
    };
  }
}
