import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/event_model.dart';
import '../models/registration_model.dart';
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

  static Future<Map<String, dynamic>> registerEventUser({
    required int eventId,
    required String kategoriLomba,
    required String namaPeserta,
    required String emailPeserta,
    required String namaBib,
    required String nohpPeserta,
    required String alamatPeserta,
    required String kotaPeserta,
    required String provinsiPeserta,
    required String tanggalLahir,
    required String jenisKelamin,
    required String ukuranJersey,
    required String golonganDarah,
    required String namaKontakDarurat,
    required String nomorKontakDarurat,
    String? riwayatPenyakit,
    required bool pernyataanSehat,
    Uint8List? scanWajahBytes,
    String? scanWajahName,
  }) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/event/register/$eventId');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['kategori_lomba'] = kategoriLomba;
    request.fields['nama_peserta'] = namaPeserta;
    request.fields['email_peserta'] = emailPeserta;
    request.fields['nama_bib'] = namaBib;
    request.fields['nohp_peserta'] = nohpPeserta;
    request.fields['alamat_peserta'] = alamatPeserta;
    request.fields['kota_peserta'] = kotaPeserta;
    request.fields['provinsi_peserta'] = provinsiPeserta;
    request.fields['tanggal_lahir'] = tanggalLahir;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['ukuran_jersey'] = ukuranJersey;
    request.fields['golongan_darah'] = golonganDarah;
    request.fields['nama_kontak_darurat'] = namaKontakDarurat;
    request.fields['nomor_kontak_darurat'] = nomorKontakDarurat;
    request.fields['pernyataan_sehat'] = pernyataanSehat ? 'true' : 'false';
    if (riwayatPenyakit != null && riwayatPenyakit.isNotEmpty) {
      request.fields['riwayat_penyakit'] = riwayatPenyakit;
    }

    if (scanWajahBytes != null && scanWajahName != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'scan_wajah',
        scanWajahBytes,
        filename: scanWajahName,
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {'msg': response.body};
    }
    return {
      'status': response.statusCode,
      'data': body,
    };
  }

  static Future<Map<String, dynamic>> uploadPaymentProof({
    required int registrationId,
    required Uint8List proofBytes,
    required String proofName,
  }) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) {
      throw Exception('Token tidak tersedia. Silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/event/payment/$registrationId');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(http.MultipartFile.fromBytes(
      'bukti',
      proofBytes,
      filename: proofName,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = {'msg': response.body};
    }
    return {
      'status': response.statusCode,
      'data': body,
    };
  }

  // Fetch user's event registration history (endpoint: GET /event/me)
  static Future<List<RegistrationModel>> getMyRegistrations() async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) return [];

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/me'),
      headers: headers,
    );

    if (response.statusCode != 200) return [];

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = [];
    }

    final items = body is List ? body : [];
    return (items as List<dynamic>)
        .map((e) => RegistrationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Fetch all registrations for EO (endpoint: GET /event/registrations)
  static Future<List<RegistrationModel>> getRegistrationsForEO() async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) return [];

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/registrations'),
      headers: headers,
    );

    if (response.statusCode != 200) return [];

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = [];
    }

    final items = body is List ? body : (body['data'] is List ? body['data'] : []);
    return (items as List<dynamic>)
        .map((e) => RegistrationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch registrations for a specific event (EO-only endpoint)
  static Future<List<RegistrationModel>> getRegistrationsForEvent(int eventId) async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) return [];

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/event/registrations/$eventId'), headers: headers);

    if (response.statusCode != 200) {
      return [];
    }

    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (_) {
      body = [];
    }

    final items = body is List ? body : (body['data'] is List ? body['data'] : []);
    return (items as List<dynamic>).map((e) => RegistrationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Approve payment — endpoint: PUT /event/approve-payment/:id
  static Future<bool> approveRegistration(int registrationId) async {
    final token = AuthService.accessToken;
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/event/approve-payment/$registrationId'),
      headers: headers,
      body: jsonEncode({'action': 'approve'}),
    );
    return response.statusCode == 200;
  }

  // Reject payment — endpoint: PUT /event/approve-payment/:id
  static Future<bool> rejectRegistration(int registrationId, String reason) async {
    final token = AuthService.accessToken;
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/event/approve-payment/$registrationId'),
      headers: headers,
      body: jsonEncode({'action': 'reject', 'reason': reason}),
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> verifyScan(String code) async {
    final token = AuthService.accessToken;
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/event/verify-scan/$code'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<bool> checkinParticipant(int registrationId) async {
    final token = AuthService.accessToken;
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/event/checkin/$registrationId'),
      headers: headers,
    );
    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getScanHistory() async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) return [];

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/event/scan-history'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print('Error fetching scan history: $e');
    }
    return [];
  }

  static Future<bool> checkinEventParticipant(int registrationId) async {
    final token = AuthService.accessToken;
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/event/checkin-event/$registrationId'),
      headers: headers,
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> matchFace() async {
    final token = AuthService.accessToken;
    if (token == null || token.isEmpty) return null;

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/event/match-face'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error matching face: $e');
    }
    return null;
  }
}
