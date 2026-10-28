import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_screen.dart';

// Worksheet 5, Ex 5: widget tests for the basket page.
//
// A fixed sample film priced at £10.00. The basket page doesn't draw
// posters, so the path never needs to exist.
const Movie testMovie = Movie(
  id: 'test-film',
  title: 'Test Film',
  ageRating: 'PG',
  runtime: '1h 30m',
  description: 'A film used for testing.',
  screeningTime: 'Friday 23 Oct 2026, 20:00',
  price: 10.0,
  posterPath: 'assets/images/test.jpg',
);

void main() {
  // The basket is a singleton, so clear it before every test.
  setUp(() {
    BasketRepository.instance.clear();
  });

  // Checks the empty state: the message shows and there is no Checkout.
  testWidgets('BasketScreen displays empty message when basket has no items', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(find.text('Checkout'), findsNothing);
  });

  // Checks a basket with 2 tickets: the line, its cost and Checkout show,
  // then tapping the delete icon empties the basket.
  testWidgets('BasketScreen renders items and removes item when delete pressed',
      (WidgetTester tester) async {
    const BasketItem item = BasketItem(
      movie: testMovie,
      quantity: 2,
    );
    BasketRepository.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    expect(find.text('Your basket'), findsOneWidget);
    expect(find.text('2 x Test Film'), findsOneWidget);
    // £20.00 appears twice: as the line cost and as the total to pay.
    expect(find.text('£20.00'), findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your basket is empty'), findsOneWidget);
  });

  // Extra test (not in the worksheet): the page has a Checkout button, so
  // this checks it empties the basket and shows the thank-you message.
  testWidgets('Checkout empties the basket and shows a confirmation', (
    WidgetTester tester,
  ) async {
    const BasketItem item = BasketItem(
      movie: testMovie,
      quantity: 1,
    );
    BasketRepository.instance.addItem(item);

    await tester.pumpWidget(const MaterialApp(home: BasketScreen()));

    await tester.tap(find.text('Checkout'));
    await tester.pump();

    expect(find.text('Thanks, your tickets are booked'), findsOneWidget);
    expect(find.text('Your basket is empty'), findsOneWidget);
    expect(BasketRepository.instance.getItems(), isEmpty);
  });
}
