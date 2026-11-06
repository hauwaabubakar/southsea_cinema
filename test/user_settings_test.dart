import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

// Worksheet 5, Ex 6: unit tests for the UserSettings model.
void main() {
  group('UserSettings tests', () {
    // Test 1: with no values given, the defaults are used.
    test('default UserSettings has empty strings and newsletter off', () {
      const UserSettings settings = UserSettings();

      expect(settings.address, isEmpty);
      expect(settings.email, isEmpty);
      expect(settings.patronNumber, isEmpty);
      expect(settings.receiveNewsletter, isFalse);
    });

    // Test 2: values passed to the constructor are stored.

    test('configured UserSettings stores the values passed in', () {
      const UserSettings settings = UserSettings(
        address: 'Buckingham Building, Lion Terrace, Portsmouth, PO1 3HE',
        email: 'alex@example.com',
        patronNumber: '1234',
        receiveNewsletter: true,
      );

      expect(
        settings.address,
        'Buckingham Building, Lion Terrace, Portsmouth, PO1 3HE',
      );
      expect(settings.email, 'alex@example.com');
      expect(settings.patronNumber, '1234');
      expect(settings.receiveNewsletter, isTrue);
    });
  });
}
