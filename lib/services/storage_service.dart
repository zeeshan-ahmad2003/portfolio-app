import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _themeKey = 'isDarkMode';
  static const _nameKey = 'userName';
  static const _bioKey = 'userBio';
  static const _emailKey = 'userEmail';
  static const _phoneKey = 'userPhone';

  // ── Theme ──
  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? true; // default dark
  }

  // ── Profile ──
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
}
