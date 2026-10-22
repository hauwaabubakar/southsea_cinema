import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

// Builds the app and taps a BOOK NOW button to open a listing page.
Future<void> openListing(WidgetTester tester, {bool last = false}) async {
  await tester.pumpWidget(const SouthseaCinemaApp());
  await tester.pumpAndSettle();

  final Finder button =
      last ? find.text('BOOK NOW').last : find.text('BOOK NOW').first;

  if (last) {
    // Scroll down to the second movie.
    await tester.drag(
      //simulates a user swiping upwards to scroll down the movie list.
      find.byType(ListView).first,
      const Offset(0, -400), // moves list 400 pixels up
    );
    await tester.pumpAndSettle(); //waits for scroling to finish
  }

  await tester.ensureVisible(button);
  await tester.pumpAndSettle();

  await tester.tap(button); //then presses the button
  await tester.pumpAndSettle();
}

void main() {
  group('Home page widget tests', () {
    testWidgets('home page shows title, films and booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text(appTitle), findsOneWidget);
      expect(find.text('The Odyssey (15)'), findsOneWidget);
      expect(find.text('The Conjuring 2 (15)'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsNWidgets(2));
    });

    testWidgets('drawer shows only the Home link', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Movie Listing'), findsNothing);
    });
  });

  group('Navigation widget tests', () {
    testWidgets('first BOOK NOW opens the listing for The Odyssey',
        (WidgetTester tester) async {
      await openListing(tester);

      expect(find.byType(MovieListing), findsOneWidget);
      expect(find.text('THE ODYSSEY (15)'), findsOneWidget);
      expect(find.text('Runtime: 2h 53m'), findsOneWidget);
    });

    testWidgets('second BOOK NOW opens the listing for The Conjuring 2',
        (WidgetTester tester) async {
      await openListing(tester, last: true);

      expect(find.text('THE CONJURING 2 (15)'), findsOneWidget);
      expect(find.text('Runtime: 2h 14m'), findsOneWidget);
    });

    testWidgets('listing page shows the film poster',
        (WidgetTester tester) async {
      await openListing(tester);

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('system back returns to the home page',
        (WidgetTester tester) async {
      await openListing(tester);
      expect(find.byType(MovieListing), findsOneWidget);

      // The listing page has a drawer, so its app bar shows the menu
      // icon, not a back arrow. Use the system back action instead.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsNothing);
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('BOOK NOW'), findsNWidgets(2));
    });
  });
  group('Booking widget tests', () {
    testWidgets('ADD TO ORDER with no tickets asks for a ticket',
        (WidgetTester tester) async {
      await openListing(tester);

      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();

      expect(find.text('Please select at least one ticket.'), findsOneWidget);
    });

    testWidgets('dropdown selection is used by ADD TO ORDER',
        (WidgetTester tester) async {
      await openListing(tester);

      // Open the dropdown and choose 3 tickets.
      await tester.ensureVisible(find.byType(DropdownMenu<int>));
      await tester.tap(find.byType(DropdownMenu<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3').last);
      await tester.pumpAndSettle();

      // Press ADD TO ORDER and check the message uses the choice.
      await tester.ensureVisible(find.text('ADD TO ORDER'));
      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pumpAndSettle();

      expect(
        find.text('Added 3 ticket(s) for The Odyssey to your order.'),
        findsOneWidget,
      );
    });
  });
}
