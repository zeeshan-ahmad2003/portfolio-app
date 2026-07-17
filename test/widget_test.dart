// Basic smoke test for the portfolio app.
//
// Verifies the app builds without throwing and shows the initial
// splash/auth-check screen (the "_ZA✨" branding) before either the
// login screen or main screen takes over.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_app/main.dart';

void main() {
  testWidgets('App builds and shows splash screen without crashing', (
    WidgetTester tester,
  ) async {
    // Build our app with a fixed initial theme and trigger a frame.
    await tester.pumpWidget(const MyApp(initialDarkMode: true));

    // AuthWrapper starts in its "_checking" state, showing the splash
    // screen with the app's branding while it checks login status.
    expect(find.text('_ZA✨'), findsOneWidget);

    // The splash screen should show a loading indicator while
    // ApiService.isLoggedIn() resolves.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
