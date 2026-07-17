// Tests for StorageService: verifies theme and profile data actually
// persist through save/load cycles using SharedPreferences.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portfolio_app/services/storage_service.dart';

void main() {
  // SharedPreferences needs its test-mode mock values set before each test,
  // otherwise it has no platform channel to talk to in the test environment.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Theme persistence', () {
    test('Saved theme preference is loaded back correctly', () async {
      await StorageService.saveTheme(false);
      final loaded = await StorageService.loadTheme();
      expect(loaded, false);
    });

    test('Defaults to dark mode when nothing has been saved yet', () async {
      final loaded = await StorageService.loadTheme();
      expect(loaded, true);
    });
  });

  group('Profile persistence', () {
    test('Saved profile fields are loaded back exactly as saved', () async {
      await StorageService.saveProfile(
        name: 'Test Name',
        bio: 'Test bio text',
        email: 'test@example.com',
        phone: '0300-1234567',
      );

      final loaded = await StorageService.loadProfile();

      expect(loaded['name'], 'Test Name');
      expect(loaded['bio'], 'Test bio text');
      expect(loaded['email'], 'test@example.com');
      expect(loaded['phone'], '0300-1234567');
    });

    test(
      'Falls back to sensible defaults when no profile was ever saved',
      () async {
        final loaded = await StorageService.loadProfile();

        // These are the defaults defined in StorageService.loadProfile().
        expect(loaded['name'], 'Zeeshan Ahmad');
        expect(loaded['email'], 'z.ahmad2003x@gmail.com');
      },
    );
  });

  group('Cache persistence', () {
    test('Cached API data round-trips through save and load', () async {
      final testData = {'name': 'Cached Name', 'email': 'cached@test.com'};

      await StorageService.cacheProfile(testData);
      final loaded = await StorageService.getCachedProfile();

      expect(loaded, isNotNull);
      expect(loaded['name'], 'Cached Name');
    });

    test('Returns null when nothing has been cached yet', () async {
      final loaded = await StorageService.getCachedProjects();
      expect(loaded, isNull);
    });

    test('clearCache removes every cached key', () async {
      await StorageService.cacheProfile({'name': 'X'});
      await StorageService.cacheProjects([1, 2, 3]);

      await StorageService.clearCache();

      expect(await StorageService.getCachedProfile(), isNull);
      expect(await StorageService.getCachedProjects(), isNull);
    });
  });
}
