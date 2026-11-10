import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/views/settings_screen.dart';

// Worksheet 5, Ex 6 and Worksheet 6, Ex 5: widget tests for the settings
// form, including loading and saving preferences.
void main() {
  // Before every test, use an EMPTY in-memory store instead of the real
  // storage, so tests never read or change a real saved profile.
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  // Test 1: everything on the form is on screen.
  testWidgets('SettingsScreen displays form fields and switch', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    // Waits for the saved values to finish loading.
    await tester.pumpAndSettle();

    expect(find.text('My Settings'), findsOneWidget);
    // Address, email and patron number.
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Receive news by email'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
  });

  // Test 2 (new, Worksheet 6): the form fills itself in from saved values.
  testWidgets('SettingsScreen pre-fills saved settings on open', (
    WidgetTester tester,
  ) async {
    // Replace the empty store with one that already holds a saved profile.
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: '10 Elm Road, Southsea',
      prefEmail: 'alex@example.com',
      prefPatronNumber: '1234',
      prefNewsletter: true,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    // Each saved value appears in its box.
    expect(find.text('10 Elm Road, Southsea'), findsOneWidget);
    expect(find.text('alex@example.com'), findsOneWidget);
    expect(find.text('1234'), findsOneWidget);
    // find.byType(Switch) finds the switch by its type, and
    // tester.widget<Switch> lets us read its value.
    final Switch switchWidget = tester.widget<Switch>(find.byType(Switch));
    expect(switchWidget.value, isTrue);
  });

  // Test 3 (updated, Worksheet 6): type, flip the switch, save, then check
  // the confirmation, the stored values, and a reopened screen.
  testWidgets('Toggling switch and saving settings updates state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    // Find each box by its label text.
    final Finder addressField = find.widgetWithText(TextField, 'Address');
    final Finder emailField = find.widgetWithText(TextField, 'Email Address');
    final Finder patronField = find.widgetWithText(TextField, 'Patron Number');

    // enterText types into a box like a user would.
    await tester.enterText(addressField, '25 Seaview Road, Southsea');
    await tester.enterText(emailField, 'sam@example.com');
    await tester.enterText(patronField, '5678');

    // The switch starts off. Tapping it turns it on.
    final Finder switchFinder = find.byType(Switch);
    expect(tester.widget<Switch>(switchFinder).value, isFalse);
    await tester.ensureVisible(switchFinder);
    await tester.pumpAndSettle();
    await tester.tap(switchFinder);
    await tester.pump();
    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    // Press SAVE SETTINGS. pumpAndSettle lets the saves finish first.
    await tester.ensureVisible(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved'), findsOneWidget);

    // Read the in-memory store to prove the values were really SAVED, not
    // just shown in the form.
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getString(prefAddress), '25 Seaview Road, Southsea');
    expect(await prefs.getString(prefEmail), 'sam@example.com');
    expect(await prefs.getString(prefPatronNumber), '5678');
    expect(await prefs.getBool(prefNewsletter), isTrue);

    // Pumping an empty widget removes the settings screen, so the next
    // pumpWidget builds a fresh one that must load the saved values again.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('25 Seaview Road, Southsea'), findsOneWidget);
    expect(find.text('sam@example.com'), findsOneWidget);
    expect(find.text('5678'), findsOneWidget);
    final Switch reopenedSwitch = tester.widget<Switch>(find.byType(Switch));
    expect(reopenedSwitch.value, isTrue);
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

  // Extra test (not in the worksheet): after details are loaded, CANCEL
  // returns the form to those LOADED values, not to empty boxes.
  testWidgets('CANCEL restores the loaded values', (
    WidgetTester tester,
  ) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: '10 Elm Road, Southsea',
      prefEmail: 'alex@example.com',
      prefPatronNumber: '1234',
      prefNewsletter: false,
    });

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    await tester.pumpAndSettle();

    // Change the email, then cancel.
    final Finder emailField = find.widgetWithText(TextField, 'Email Address');
    await tester.enterText(emailField, 'changed@example.com');
    expect(find.text('changed@example.com'), findsOneWidget);

    await tester.ensureVisible(find.text('CANCEL'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CANCEL'));
    await tester.pump();

    // The loaded email is back.
    expect(find.text('changed@example.com'), findsNothing);
    expect(find.text('alex@example.com'), findsOneWidget);
  });
}
