import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

class ApiService {
  static const String _base = 'http://10.0.2.2:3000';
  static const Duration _timeout = Duration(seconds: 10);
  static const String _tokenKey = 'auth_token';

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

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static const _publicHeaders = {'Content-Type': 'application/json'};

  // ── Week 6: centralized error classification ────────────────
  // Turns any thrown error into a clear, user-facing message
  // instead of leaking exception text or failing silently.
  static String _describeError(Object e) {
    if (e is SocketException) {
      return 'Cannot reach server. Check your connection and try again.';
    }
    if (e is TimeoutException) {
      return 'Request timed out. Please try again.';
    }
    if (e is FormatException) {
      return 'Received an invalid response from the server.';
    }
    return 'Something went wrong. Please try again.';
  }

  // Safely decodes a response body; returns null instead of throwing
  // if the server sent something that isn't valid JSON.
  static Map<String, dynamic>? _safeDecode(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Week 6: basic input validation ──────────────────────────
  static bool _isValidEmail(String email) {
    return RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$').hasMatch(email.trim());
  }

  // ── Login ────────────────────────────────────────────────
  static Future<ApiResponse> login(String email, String password) async {
    final trimmedEmail = email.trim();

    // Validate before ever touching the network
    if (trimmedEmail.isEmpty || password.isEmpty) {
      return ApiResponse.fail('Please enter both email and password.');
    }
    if (!_isValidEmail(trimmedEmail)) {
      return ApiResponse.fail('Please enter a valid email address.');
    }

    try {
      final res = await http
          .post(
            Uri.parse('$_base/api/login'),
            headers: _publicHeaders,
            body: jsonEncode({'email': trimmedEmail, 'password': password}),
          )
          .timeout(_timeout);

      final body = _safeDecode(res);
      if (body == null) {
        return ApiResponse.fail(_describeError(const FormatException()));
      }

      if (res.statusCode == 200 && body['success'] == true) {
        final token = body['token'];
        if (token == null || token.toString().isEmpty) {
          return ApiResponse.fail('Login succeeded but no token was returned.');
        }
        await saveToken(token);
        return ApiResponse.ok(body);
      }

      if (res.statusCode == 401) {
        return ApiResponse.fail('Incorrect email or password.');
      }
      return ApiResponse.fail(
        body['message'] ?? 'Login failed. Please try again.',
      );
    } on SocketException catch (e) {
      return ApiResponse.fail(_describeError(e));
    } on TimeoutException catch (e) {
      return ApiResponse.fail(_describeError(e));
    } catch (e) {
      return ApiResponse.fail(_describeError(e));
    }
  }

  // ── Logout ───────────────────────────────────────────────
  static Future<void> logout() async {
    try {
      final headers = await _authHeaders();
      await http
          .post(Uri.parse('$_base/api/logout'), headers: headers)
          .timeout(_timeout);
    } catch (_) {
      // Logout should never block on network failure —
      // we clear local state regardless.
    }
    await clearToken();
    await StorageService.clearCache();
  }

  // ── Profile ──────────────────────────────────────────────
  static Future<ApiResponse> getProfile() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/profile'), headers: _publicHeaders)
          .timeout(_timeout);

      final body = _safeDecode(res);
      if (body == null || res.statusCode != 200) {
        throw const FormatException();
      }

      final data = body['data'];
      if (data == null) {
        return ApiResponse.fail('Profile data is empty.');
      }
      await StorageService.cacheProfile(data);
      return ApiResponse.ok(data);
    } catch (e) {
      final cached = await StorageService.getCachedProfile();
      if (cached != null) return ApiResponse.cached(cached);
      return ApiResponse.fail(_describeError(e));
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

      final body = _safeDecode(res);
      if (body == null) {
        return ApiResponse.fail(_describeError(const FormatException()));
      }
      if (body['success'] == true) return ApiResponse.ok(body['data']);
      return ApiResponse.fail(
        body['message'] ?? 'Update failed. Please try again.',
      );
    } catch (e) {
      return ApiResponse.fail(_describeError(e));
    }
  }

  static Future<ApiResponse> uploadProfileImage(File imageFile) async {
    // Guard against a stale/missing file path before hitting the network.
    if (!await imageFile.exists()) {
      return ApiResponse.fail('Selected image could not be found.');
    }

    try {
      final token = await getToken();
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('$_base/api/profile/image'),
      );
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      final streamed = await request.send().timeout(_timeout);
      final res = await http.Response.fromStream(streamed);

      final body = _safeDecode(res);
      if (body == null) {
        return ApiResponse.fail(_describeError(const FormatException()));
      }
      if (body['success'] == true) return ApiResponse.ok(body);
      return ApiResponse.fail(
        body['message'] ?? 'Upload failed. Please try again.',
      );
    } catch (e) {
      return ApiResponse.fail(_describeError(e));
    }
  }

  // ── Projects ─────────────────────────────────────────────
  static Future<ApiResponse> getProjects({
    String? category,
    String? search,
  }) async {
    final isDefaultQuery =
        (category == null || category == 'All') &&
        (search == null || search.isEmpty);

    try {
      final params = <String, String>{};
      if (category != null && category != 'All') params['category'] = category;
      if (search != null && search.isNotEmpty) params['search'] = search.trim();

      final uri = Uri.parse(
        '$_base/api/projects',
      ).replace(queryParameters: params);
      final res = await http
          .get(uri, headers: _publicHeaders)
          .timeout(_timeout);

      final body = _safeDecode(res);
      if (body == null || res.statusCode != 200) {
        throw const FormatException();
      }

      final data = body['data'];
      // Only cache the unfiltered result set, so cached data always
      // reflects "everything", not whatever the user last searched for.
      if (isDefaultQuery) {
        await StorageService.cacheProjects(data);
      }
      return ApiResponse.ok(data ?? []);
    } catch (e) {
      // A filtered/search query that fails should not silently fall back
      // to the full cached list — that would be misleading to the user.
      if (!isDefaultQuery) {
        return ApiResponse.fail(_describeError(e));
      }
      final cached = await StorageService.getCachedProjects();
      if (cached != null) return ApiResponse.cached(cached);
      return ApiResponse.fail(_describeError(e));
    }
  }

  // ── Skills ───────────────────────────────────────────────
  static Future<ApiResponse> getSkills() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/skills'), headers: _publicHeaders)
          .timeout(_timeout);

      final body = _safeDecode(res);
      if (body == null || res.statusCode != 200) {
        throw const FormatException();
      }

      final data = body['data'];
      await StorageService.cacheSkills(data);
      return ApiResponse.ok(data ?? []);
    } catch (e) {
      final cached = await StorageService.getCachedSkills();
      if (cached != null) return ApiResponse.cached(cached);
      return ApiResponse.fail(_describeError(e));
    }
  }

  // ── Contact ──────────────────────────────────────────────
  static Future<ApiResponse> getContact() async {
    try {
      final res = await http
          .get(Uri.parse('$_base/api/contact'), headers: _publicHeaders)
          .timeout(_timeout);

      final body = _safeDecode(res);
      if (body == null || res.statusCode != 200) {
        throw const FormatException();
      }

      final data = body['data'];
      if (data == null) {
        return ApiResponse.fail('Contact data is empty.');
      }
      await StorageService.cacheContact(data);
      return ApiResponse.ok(data);
    } catch (e) {
      final cached = await StorageService.getCachedContact();
      if (cached != null) return ApiResponse.cached(cached);
      return ApiResponse.fail(_describeError(e));
    }
  }
}

// ── ApiResponse — Week 5: fromCache flag; Week 6: isEmpty helper ──
class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;
  final bool fromCache;

  ApiResponse._({
    required this.success,
    this.data,
    this.error,
    this.fromCache = false,
  });

  // Live API success
  factory ApiResponse.ok(dynamic data) =>
      ApiResponse._(success: true, data: data, fromCache: false);

  // Offline cache success
  factory ApiResponse.cached(dynamic data) =>
      ApiResponse._(success: true, data: data, fromCache: true);

  // Failure
  factory ApiResponse.fail(String msg) =>
      ApiResponse._(success: false, error: msg);

  // ── Week 6: lets screens show a proper "no data" empty state
  // instead of an empty list rendering as a blank, confusing screen.
  bool get isEmpty {
    if (data == null) return true;
    if (data is List) return (data as List).isEmpty;
    if (data is Map) return (data as Map).isEmpty;
    return false;
  }
}
