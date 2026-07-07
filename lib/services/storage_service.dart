import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ── Week 5: Offline Cache + Profile Storage ──────────────────
class StorageService {
  static const _themeKey = 'isDarkMode';
  static const _nameKey = 'userName';
  static const _bioKey = 'userBio';
  static const _emailKey = 'userEmail';
  static const _phoneKey = 'userPhone';

  // ── Cache keys (Week 5) ──────────────────────────────────
  static const _cacheProfile = 'cache_profile';
  static const _cacheProjects = 'cache_projects';
  static const _cacheSkills = 'cache_skills';
  static const _cacheContact = 'cache_contact';

  // ── Theme ────────────────────────────────────────────────
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true;
  }

  // ── Profile (local edits) ────────────────────────────────
  static Future<void> saveProfile({
    required String name,
    required String bio,
    required String email,
    required String phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_bioKey, bio);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phone);
  }

  static Future<Map<String, String>> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? 'Zeeshan Ahmad',
      'bio':
          prefs.getString(_bioKey) ??
          'BS Computer Science student at Abdul Wali Khan University Mardan '
              '(CGPA 3.25, Batch 2023–2027). Passionate about Flutter, AI/ML, '
              'and building practical software solutions.',
      'email': prefs.getString(_emailKey) ?? 'z.ahmad2003x@gmail.com',
      'phone': prefs.getString(_phoneKey) ?? '0310-9803584',
    };
  }

  // ── Offline Cache helpers (Week 5) ───────────────────────
  static Future<void> _save(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(data));
  }

  static Future<dynamic> _load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  // Profile cache
  static Future<void> cacheProfile(dynamic data) => _save(_cacheProfile, data);
  static Future<dynamic> getCachedProfile() => _load(_cacheProfile);

  // Projects cache
  static Future<void> cacheProjects(dynamic data) =>
      _save(_cacheProjects, data);
  static Future<dynamic> getCachedProjects() => _load(_cacheProjects);

  // Skills cache
  static Future<void> cacheSkills(dynamic data) => _save(_cacheSkills, data);
  static Future<dynamic> getCachedSkills() => _load(_cacheSkills);

  // Contact cache
  static Future<void> cacheContact(dynamic data) => _save(_cacheContact, data);
  static Future<dynamic> getCachedContact() => _load(_cacheContact);

  // Clear all API cache (called on logout)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheProfile);
    await prefs.remove(_cacheProjects);
    await prefs.remove(_cacheSkills);
    await prefs.remove(_cacheContact);
  }
}
