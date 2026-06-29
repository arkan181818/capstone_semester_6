import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/event_model.dart';
import 'auth_service.dart';

class EventService {
  static Future<List<EventModel>> getEOEvents() async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {
        'msg': response.body,
      };
    }

    if (response.statusCode != 200) {
      final message = body['msg'] ?? 'Gagal memuat event';
      throw Exception(message);
    }

    final items = body as List<dynamic>;
    return items.map((item) {
      final map = item as Map<String, dynamic>;
      final banner = map['banner'] as String?;
      return EventModel.fromJson({
        ...map,
        'banner': banner != null && banner.isNotEmpty
            ? '${ApiConfig.baseUrl}/$banner'
            : null,
      });
    }).toList();
  }

  // User endpoints
  static Future<List<EventModel>> getUserEvents() async {
    final token = AuthService.accessToken;

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/list'),
      headers: headers,
    );

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {
        'msg': response.body,
      };
    }

    if (response.statusCode != 200) {
      final message = (body is Map && body['msg'] != null) ? body['msg'] : 'Gagal memuat event';
      throw Exception(message);
    }

    final items = body is List ? body : (body['data'] is List ? body['data'] : []);
    return (items as List<dynamic>).map((item) {
      final map = item as Map<String, dynamic>;
      final banner = map['banner'] as String?;
      return EventModel.fromJson({
        ...map,
        'banner': banner != null && banner.isNotEmpty ? '${ApiConfig.baseUrl}/$banner' : null,
      });
    }).toList();
  }

  static Future<EventModel> getEventDetail(int eventId) async {
    final token = AuthService.accessToken;

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/detail/$eventId'),
      headers: headers,
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200) {
      final message = body['msg'] ?? 'Gagal memuat detail event';
      throw Exception(message);
    }

    final map = body is Map<String, dynamic> ? body : (body['data'] as Map<String, dynamic>);
    final banner = map['banner'] as String?;
    return EventModel.fromJson({
      ...map,
      'banner': banner != null && banner.isNotEmpty ? '${ApiConfig.baseUrl}/$banner' : null,
    });
  }

  static Future<Map<String, dynamic>> createEvent({
    required int categoryId,
    required String namaEvent,
    required String tanggal,
    required String lokasi,
    String? deskripsi,
    required String harga,
    required int kuota,
    Uint8List? bannerBytes,
    String? bannerName,
  }) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/event/');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['category_id'] = categoryId.toString();
    request.fields['nama_event'] = namaEvent;
    request.fields['tanggal'] = tanggal;
    request.fields['lokasi'] = lokasi;
    request.fields['harga'] = harga;
    request.fields['kuota'] = kuota.toString();
    if (deskripsi != null) {
      request.fields['deskripsi'] = deskripsi;
    }

    if (bannerBytes != null && bannerName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'banner',
        bannerBytes,
        filename: bannerName,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {
        'msg': response.body,
      };
    }
    return {
      'status': response.statusCode,
      'data': body,
    };
  }

  static Future<Map<String, dynamic>> updateEvent({
    required int eventId,
    int? categoryId,
    String? namaEvent,
    String? tanggal,
    String? lokasi,
    String? deskripsi,
    String? harga,
    int? kuota,
    Uint8List? bannerBytes,
    String? bannerName,
  }) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/event/$eventId');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    if (categoryId != null) request.fields['category_id'] = categoryId.toString();
    if (namaEvent != null) request.fields['nama_event'] = namaEvent;
    if (tanggal != null) request.fields['tanggal'] = tanggal;
    if (lokasi != null) request.fields['lokasi'] = lokasi;
    if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
    if (harga != null) request.fields['harga'] = harga;
    if (kuota != null) request.fields['kuota'] = kuota.toString();

    if (bannerBytes != null && bannerName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'banner',
        bannerBytes,
        filename: bannerName,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {
        'msg': response.body,
      };
    }
    return {
      'status': response.statusCode,
      'data': body,
    };
  }

  static Future<Map<String, dynamic>> deleteEvent(int eventId) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/event/$eventId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);
    return {
      'status': response.statusCode,
      'data': body,
    };
  }
}
