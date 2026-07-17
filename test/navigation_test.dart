// Tests for bottom navigation: confirms tapping each nav item switches
// to the correct screen. Uses MainScreen directly (bypassing AuthWrapper
// and login) since navigation between tabs doesn't depend on auth state.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portfolio_app/main.dart';

void main() {
  // ProfileScreen and HomeScreen both call StorageService, which reads
  // SharedPreferences on initState. Without a mock, that platform channel
  // call never resolves in the test environment, leaving screens stuck
  // in their loading state indefinitely.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildMainScreen() {
    return MaterialApp(
      home: MainScreen(isDarkMode: true, onToggleTheme: () {}, onLogout: () {}),
    );
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
  }

  testWidgets('Starts on the Home tab by default', (WidgetTester tester) async {
    await tester.pumpWidget(buildMainScreen());
    await settle(tester);

    expect(find.text('_ZA✨'), findsOneWidget);
  });

  testWidgets('Tapping Projects switches to the Projects screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildMainScreen());
    await settle(tester);

    await tester.tap(find.text('Projects').last);
    await settle(tester);

    expect(find.text('My Projects'), findsOneWidget);
  });

  testWidgets('Tapping Contact switches to the Contact screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildMainScreen());
    await settle(tester);

    await tester.tap(find.text('Contact').last);
    await settle(tester);

    expect(find.text('Contact Me'), findsOneWidget);
  });

  testWidgets('Tapping Profile switches to the Profile screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildMainScreen());
    await settle(tester);

    await tester.tap(find.text('Profile').last);
    await settle(tester);

    expect(find.text('Edit Profile'), findsOneWidget);
  });

  testWidgets('Tapping Home returns to the Home screen from another tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildMainScreen());
    await settle(tester);

    await tester.tap(find.text('Contact').last);
    await settle(tester);
    expect(find.text('Contact Me'), findsOneWidget);

    await tester.tap(find.text('Home').last);
    await settle(tester);
    expect(find.text('_ZA✨'), findsOneWidget);
  });
}
