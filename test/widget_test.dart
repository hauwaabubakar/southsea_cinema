import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  group('Home page widget tests', () {
    // Exercise 4: home page shows title, films and booking buttons.
    testWidgets('home page shows title, films and booking buttons',
        (WidgetTester tester) async {
      // Build the whole app, then wait for everything to finish drawing.
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      // The app bar title.
      expect(find.text(appTitle), findsOneWidget);

      // One card per film (the card shows "Title (rating)").
      expect(find.text('The Odyssey (15)'), findsOneWidget);
      expect(find.text('The Conjuring 2 (15)'), findsOneWidget);

      // One BOOK button on each card.
      expect(find.text('BOOK'), findsNWidgets(2));
    });

    // Exercise 6: tapping BOOK opens the listing page for that film.
    testWidgets('tapping BOOK opens the listing page for that film',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      // Tap the first BOOK button (The Odyssey).
      await tester.tap(find.text('BOOK').first);
      await tester.pumpAndSettle();

      // The listing page shows that film's details.
      expect(find.text('THE ODYSSEY (15)'), findsOneWidget);
      expect(
        find.text('Thursday 22 Oct 2026, 18:00 - ends at 20:53'),
        findsOneWidget,
      );
      expect(find.text('Runtime: 2h 53m'), findsOneWidget);

      // Tap ADD TO ORDER with no tickets selected.
      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();

      expect(find.text('Please select at least one ticket.'), findsOneWidget);
    });

    // Exercise 6: the second BOOK button opens the second film.
    testWidgets('second BOOK button opens the second film',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('BOOK').last);
      await tester.tap(find.text('BOOK').last);
      await tester.pumpAndSettle();

      expect(find.text('THE CONJURING 2 (15)'), findsOneWidget);
      expect(find.text('Runtime: 2h 14m'), findsOneWidget);
    });
  });
}
