import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../services/auth_service.dart';

class AdminService {
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthService.accessToken ?? ''}',
      };

  // ── Dashboard Stats ────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getDashboardStats() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/dashboard'),
      headers: _headers,
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  // ── All Events ─────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getAllEvents() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/events'),
      headers: _headers,
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  // ── Approve Event ──────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> approveEvent(int eventId) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/admin/events/$eventId/approve'),
      headers: _headers,
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  // ── Reject Event ───────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> rejectEvent(int eventId) async {
    final res = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/admin/events/$eventId/reject'),
      headers: _headers,
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }

  // ── All Users ──────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> getAllUsers() async {
    final res = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/admin/users'),
      headers: _headers,
    );
    return {'status': res.statusCode, 'data': jsonDecode(res.body)};
  }
}
