import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Android emulator uses 10.0.2.2 to reach your Mac's localhost
  // iOS simulator uses localhost directly
  static const String _base = 'http://10.0.2.2:3000';
  // If testing on iOS simulator, change to: 'http://localhost:3000'

  static const Duration _timeout = Duration(seconds: 10);
  static const String _tokenKey = 'auth_token';

  // ── Token helpers ──────────────────────────────────────────
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Headers ────────────────────────────────────────────────
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static const _publicHeaders = {'Content-Type': 'application/json'};

  // ── Auth ───────────────────────────────────────────────────
  static Future<ApiResponse> login(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_base/api/login'),
            headers: _publicHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      if (res.statusCode == 200 && body['success'] == true) {
        await saveToken(body['token']);
        return ApiResponse.ok(body);
      }
      return ApiResponse.fail(body['message'] ?? 'Login failed');
    } on SocketException {
      return ApiResponse.fail('Cannot reach server. Is it running?');
    } catch (e) {
      return ApiResponse.fail('Error: $e');
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await _authHeaders();
      await http
          .post(Uri.parse('$_base/api/logout'), headers: headers)
          .timeout(_timeout);
    } catch (_) {}
    await clearToken();
  }

  // ── Profile ────────────────────────────────────────────────
  static Future<ApiResponse> getProfile() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/profile'), headers: _publicHeaders)
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      return ApiResponse.ok(body['data']);
    } catch (_) {
      return ApiResponse.fail('Failed to load profile');
    }
  }

  static Future<ApiResponse> updateProfile(Map<String, dynamic> data) async {
    try {
      final headers = await _authHeaders();
      final res = await http
          .put(
            Uri.parse('$_base/api/profile'),
            headers: headers,
            body: jsonEncode(data),
          )
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      if (body['success'] == true) return ApiResponse.ok(body['data']);
      return ApiResponse.fail(body['message'] ?? 'Update failed');
    } catch (_) {
      return ApiResponse.fail('Failed to update profile');
    }
  }

  static Future<ApiResponse> uploadProfileImage(File imageFile) async {
    try {
      final token = await getToken();
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_base/api/profile/image'),
      );
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      final streamed = await request.send().timeout(_timeout);
      final res = await http.Response.fromStream(streamed);
      final body = jsonDecode(res.body);
      if (body['success'] == true) return ApiResponse.ok(body);
      return ApiResponse.fail(body['message'] ?? 'Upload failed');
    } catch (_) {
      return ApiResponse.fail('Failed to upload image');
    }
  }

  // ── Projects ───────────────────────────────────────────────
  static Future<ApiResponse> getProjects({
    String? category,
    String? search,
  }) async {
    try {
      final params = <String, String>{};
      if (category != null && category != 'All') params['category'] = category;
      if (search != null && search.isNotEmpty) params['search'] = search;
      final uri = Uri.parse(
        '$_base/api/projects',
      ).replace(queryParameters: params);
      final res = await http
          .get(uri, headers: _publicHeaders)
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      return ApiResponse.ok(body['data']);
    } catch (_) {
      return ApiResponse.fail('Failed to load projects');
    }
  }

  // ── Skills ─────────────────────────────────────────────────
  static Future<ApiResponse> getSkills() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/skills'), headers: _publicHeaders)
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      return ApiResponse.ok(body['data']);
    } catch (_) {
      return ApiResponse.fail('Failed to load skills');
    }
  }

  // ── Contact ────────────────────────────────────────────────
  static Future<ApiResponse> getContact() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/contact'), headers: _publicHeaders)
          .timeout(_timeout);
      final body = jsonDecode(res.body);
      return ApiResponse.ok(body['data']);
    } catch (_) {
      return ApiResponse.fail('Failed to load contact');
    }
  }
}

// ── Simple response wrapper ────────────────────────────────
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;

  ApiResponse._({required this.success, this.data, this.error});

  factory ApiResponse.ok(dynamic data) =>
      ApiResponse._(success: true, data: data);

  factory ApiResponse.fail(String msg) =>
      ApiResponse._(success: false, error: msg);
}
