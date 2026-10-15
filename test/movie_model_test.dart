import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('creates Movie instance with given properties', () {
      const movie = Movie(
        id: 'test-film',
        title: 'Test Film',
        ageRating: 'PG',
        runtime: '1h 30m',
        description: 'A film used for testing.',
        screeningTime: 'Friday 23 Oct 2026, 20:00',
        price: 6.0,
        posterPath: 'assets/images/test.jpg',
      );

      expect(movie.id, 'test-film');
      expect(movie.title, 'Test Film');
      expect(movie.ageRating, 'PG');
      expect(movie.runtime, '1h 30m');
      expect(movie.description, 'A film used for testing.');
      expect(movie.screeningTime, 'Friday 23 Oct 2026, 20:00');
      expect(movie.price, 6.0);
      expect(movie.posterPath, 'assets/images/test.jpg');
    });

    test('formattedPrice shows pound sign and two decimals', () {
      const movie = Movie(
        id: 'price-test',
        title: 'Price Test',
        ageRating: 'U',
        runtime: '1h 00m',
        description: 'Testing price formatting.',
        screeningTime: 'Friday 23 Oct 2026, 20:00',
        price: 6.0,
        posterPath: 'assets/images/test.jpg',
      );

      expect(movie.formattedPrice, '£6.00');
    });

    test('isChildFriendly is true for U and PG only', () {
      expect(_movieWithRating('U').isChildFriendly, true);
      expect(_movieWithRating('PG').isChildFriendly, true);
      expect(_movieWithRating('12A').isChildFriendly, false);
      expect(_movieWithRating('15').isChildFriendly, false);
      expect(_movieWithRating('18').isChildFriendly, false);
    });

    test('isAdultOnly is true for 18 only', () {
      expect(_movieWithRating('18').isAdultOnly, true);
      expect(_movieWithRating('15').isAdultOnly, false);
      expect(_movieWithRating('PG').isAdultOnly, false);
    });
  });
}

// Helper that builds a Movie with the given age rating.
Movie _movieWithRating(String rating) {
  return Movie(
    id: 'rating-test',
    title: 'Rating Test',
    ageRating: rating,
    runtime: '1h 00m',
    description: 'Testing age ratings.',
    screeningTime: 'Friday 23 Oct 2026, 20:00',
    price: 7.5,
    posterPath: 'assets/images/test.jpg',
  );
}