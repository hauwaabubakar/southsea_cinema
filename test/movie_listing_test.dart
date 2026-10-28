import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

// Worksheet 5, Ex 5: widget tests for the listing page's ADD TO ORDER.
//
// A fixed sample film with a known price. The poster path points at a real
// image in assets/images/, because the listing page loads the picture and a
// missing file would make the test fail.
const Movie testMovie = Movie(
  id: 'test-film',
  title: 'Test Film',
  ageRating: 'PG',
  runtime: '1h 30m',
  description: 'A film used for testing.',
  screeningTime: 'Friday 23 Oct 2026, 20:00',
  price: 10.0,
  posterPath: 'assets/images/the_conjuring_2.jpg',
);

void main() {
  // The basket is a singleton, so clear it before every test.
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('MovieListing basket tests', () {
    // Checks the page shows the film's details and the booking controls.
    testWidgets('MovieListing shows film details and ADD TO ORDER button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: MovieListing(movie: testMovie)),
      );

      expect(find.text('TEST FILM (PG)'), findsOneWidget);
      expect(find.text('Runtime: 1h 30m'), findsOneWidget);
      expect(find.text('Tickets (£10.00 each)'), findsOneWidget);
      expect(find.text('ADD TO ORDER'), findsOneWidget);
    });

    // Checks the zero-ticket case: a warning shows and nothing is stored.
    testWidgets('Adding with no tickets shows warning and adds nothing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: MovieListing(movie: testMovie)),
      );

      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pump();

      expect(find.text('Please select at least one ticket.'), findsOneWidget);
      expect(BasketRepository.instance.getItems(), isEmpty);
    });

    // Checks the main case: choose 2 tickets, press the button, and the
    // basket now holds one line with quantity 2 for this film.
    testWidgets('Adding tickets records the quantity and film in the basket', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: MovieListing(movie: testMovie)),
      );

      // Open the dropdown and choose 2 tickets.
      await tester.ensureVisible(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2').last);
      await tester.pumpAndSettle();

      // Press ADD TO ORDER.
      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pump();

      // The shared basket now holds exactly one line.
      final List<BasketItem> items = BasketRepository.instance.getItems();
      expect(items.length, 1);

      final BasketItem added = items.first;
      expect(added.quantity, 2);
      expect(added.movie.id, 'test-film');
      expect(added.movie.title, 'Test Film');
      expect(
        find.text('Added 2 ticket(s) for Test Film to your order.'),
        findsOneWidget,
      );
    });
  });
}
