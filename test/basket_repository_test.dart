import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';

// Worksheet 5, Ex 4: unit tests for BasketRepository.
//
// Two sample films with known prices (£10.00 and £6.00). Using our own
// fixed films means the tests don't depend on the real repository data or
// on poster image files, so the sums below are predictable.
const Movie testMovie1 = Movie(
  id: 'test-film-1',
  title: 'Test Film One',
  ageRating: 'PG',
  runtime: '1h 30m',
  description: 'A film used for testing.',
  screeningTime: 'Friday 23 Oct 2026, 20:00',
  price: 10.0,
  posterPath: 'assets/images/test.jpg',
);

const Movie testMovie2 = Movie(
  id: 'test-film-2',
  title: 'Test Film Two',
  ageRating: '15',
  runtime: '2h 00m',
  description: 'Another film used for testing.',
  screeningTime: 'Saturday 24 Oct 2026, 18:00',
  price: 6.0,
  posterPath: 'assets/images/test.jpg',
);

void main() {
  // setUp runs before EVERY test. The basket is a singleton, so its list
  // survives between tests. Clearing it here means one test can't leave
  // tickets behind that break the next one.
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketRepository tests', () {
    // Checks the starting state: nothing in the basket, every total is zero.
    test('starts with empty basket and zero totals', () {
      final BasketRepository basket = BasketRepository.instance;

      expect(basket.getItems().length, 0);
      expect(basket.getTotalItems(), 0);
      expect(basket.totalItemCount, 0);
      expect(basket.getTotal(), 0.0);
    });

    // Checks adding and the maths, using the two sample films.
    test('adds items and calculates the total correctly', () {
      final BasketRepository basket = BasketRepository.instance;
      const BasketItem item1 = BasketItem(
        movie: testMovie1,
        quantity: 2,
      );
      const BasketItem item2 = BasketItem(
        movie: testMovie2,
        quantity: 1,
      );

      basket.addItem(item1);
      basket.addItem(item2);

      // Two lines, and 2 + 1 = 3 tickets in total.
      expect(basket.getItems().length, 2);
      expect(basket.getTotalItems(), 3);
      expect(basket.totalItemCount, 3);
      // 2 tickets at £10.00 plus 1 ticket at £6.00 is £26.00.
      expect(basket.getTotal(), 26.0);
    });

    // Checks removing a line by its position (index 0 is the first line).
    test('removes items correctly', () {
      final BasketRepository basket = BasketRepository.instance;
      const BasketItem item = BasketItem(
        movie: testMovie1,
        quantity: 1,
      );
      basket.addItem(item);
      expect(basket.getItems().length, 1);

      basket.removeItem(0);

      // The basket is empty again, and the total drops back to zero.
      expect(basket.getItems().length, 0);
      expect(basket.getTotal(), 0.0);
    });

    // Extra test (not in the worksheet): the exercise asks for clearing,
    // so this checks clear() empties a basket that has several lines.
    test('clear empties the basket', () {
      final BasketRepository basket = BasketRepository.instance;
      const BasketItem item1 = BasketItem(
        movie: testMovie1,
        quantity: 2,
      );
      const BasketItem item2 = BasketItem(
        movie: testMovie2,
        quantity: 1,
      );
      basket.addItem(item1);
      basket.addItem(item2);
      expect(basket.getItems().length, 2);

      basket.clear();

      expect(basket.getItems().length, 0);
      expect(basket.getTotalItems(), 0);
      expect(basket.getTotal(), 0.0);
    });
  });
}
