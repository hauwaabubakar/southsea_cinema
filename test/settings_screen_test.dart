import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/settings_screen.dart';

// Worksheet 5, Ex 6: widget tests for the settings form.
void main() {
  // NEW (Worksheet 6): before every test, use an EMPTY in-memory store
  // instead of the real storage, so tests never read or change a real
  // saved profile.
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  // Test 1: everything on the form is on screen.
  testWidgets('SettingsScreen displays form fields and switch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    // NEW: waits for the saved values to finish loading.
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    // Address, email and patron number.
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Receive news by email'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
  });

  // Test 2: type into the boxes, flip the switch, save, and check the
  // confirmation. The details are fictional, as the coursework asks.
  testWidgets('Toggling switch and saving settings shows confirmation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    // Find each box by its label text.
    final Finder addressField = find.widgetWithText(TextField, 'Address');
    final Finder emailField = find.widgetWithText(TextField, 'Email Address');
    final Finder patronField = find.widgetWithText(TextField, 'Patron Number');

    // enterText types into a box like a user would.
    await tester.enterText(addressField, '10 Elm Road, Portsmouth');
    await tester.enterText(emailField, 'alex@example.com');
    await tester.enterText(patronField, '1234');

    // The switch starts off. Tapping it turns it on.
    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.ensureVisible(switchFinder);
    await tester.pumpAndSettle();
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    // Press SAVE SETTINGS and check the message under the buttons.
    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAVE SETTINGS'));
    // CHANGED: pumpAndSettle (was pump), so the saves finish first.
    await tester.pumpAndSettle();

    expect(find.text('Settings saved'), findsOneWidget);
  });

  // Extra test (not in the worksheet): CANCEL throws away what was typed
  // since the last save and puts the saved (here, empty) values back.
  testWidgets('CANCEL discards unsaved changes', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    final Finder emailField = find.widgetWithText(TextField, 'Email Address');
    await tester.enterText(emailField, 'alex@example.com');
    expect(find.text('alex@example.com'), findsOneWidget);

    await tester.ensureVisible(find.text('CANCEL'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CANCEL'));
    await tester.pump();

    expect(find.text('alex@example.com'), findsNothing);
  });
}
