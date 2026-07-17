// Tests for the login screen: input validation and error handling.
// These run without a live backend — invalid input is rejected before
// any network call is made, matching the validation in api_service.dart.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_app/screens/login_screen.dart';

void main() {
  Widget wrapInApp(Widget child) {
    return MaterialApp(home: child);
  }

  testWidgets('Shows error when submitting with empty fields', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapInApp(LoginScreen(isDarkMode: true, onLoginSuccess: () {})),
    );

    // Tap "Sign In" without entering anything.
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    expect(find.text('Please enter email and password.'), findsOneWidget);
  });

  testWidgets('Shows error for an invalid email format', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapInApp(LoginScreen(isDarkMode: true, onLoginSuccess: () {})),
    );

    // Email validation happens before any network call, so this
    // resolves immediately without needing a live server.
    await tester.enterText(find.byType(TextField).first, 'not-an-email');
    await tester.enterText(find.byType(TextField).last, 'somepassword');
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    await tester.pump(); // second pump lets the async validation settle

    expect(find.text('Please enter a valid email address.'), findsOneWidget);
  });

  testWidgets('Error message clears when the user edits a field', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      wrapInApp(LoginScreen(isDarkMode: true, onLoginSuccess: () {})),
    );

    // Trigger the empty-fields error first.
    await tester.tap(find.text('Sign In'));
    await tester.pump();
    expect(find.text('Please enter email and password.'), findsOneWidget);

    // Typing in either field should clear the stale error immediately.
    await tester.enterText(find.byType(TextField).first, 'z@example.com');
    await tester.pump();

    expect(find.text('Please enter email and password.'), findsNothing);
  });
}
