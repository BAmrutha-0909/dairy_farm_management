import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diary_farming/main.dart';

void main() {
  testWidgets('Login screen loads and navigates to dashboard on login', (WidgetTester tester) async {
    // Build the entire app
    await tester.pumpWidget(const MyApp(isLoggedIn: false, currentUserEmail: ''));

    // Verify login screen is shown (look for Username label)
    expect(find.text('Username'), findsOneWidget);

    // Enter username and password
    await tester.enterText(find.byType(TextField).at(0), 'testuser');
    await tester.enterText(find.byType(TextField).at(1), 'password');

    // Tap the login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Since AuthService.login currently returns true immediately,
    // the dashboard screen should show up (look for "Dashboard" title)
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
