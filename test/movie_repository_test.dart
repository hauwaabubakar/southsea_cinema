import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  // Worksheet 6: connects the tests to Flutter services, so they can read
  // assets. Plain test() calls don't do this automatically.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MovieRepository unit tests', () {
    test('getMovies returns at least two movies', () {
      final MovieRepository repository = MovieRepository();

      expect(repository.getMovies().length, greaterThanOrEqualTo(2));
    });

    test('every movie has valid details and a unique id', () {
      final List<Movie> movies = MovieRepository().getMovies();
      final Set<String> ids = {};

      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
        expect(movie.price, greaterThan(0));
        ids.add(movie.id);
      }

      // A Set drops duplicates, so equal lengths means every id is unique.
      expect(ids.length, movies.length);
    });

    test('getMovieById returns the matching movie when id exists', () {
      final Movie? movie = MovieRepository().getMovieById('the-odyssey');

      expect(movie, isNotNull);
      expect(movie?.title, 'The Odyssey');
    });

    test('getMovieById returns null when id does not exist', () {
      final Movie? movie = MovieRepository().getMovieById('non-existent');

      expect(movie, isNull);
    });

    test('getMoviesByAgeRating returns only films with that rating', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> fifteens = repository.getMoviesByAgeRating('15');

      expect(fifteens, isNotEmpty);
      expect(fifteens.every((movie) => movie.ageRating == '15'), true);
      expect(repository.getMoviesByAgeRating('18'), isEmpty);
    });

    test('getMoviesUnderPrice returns only films at or under the price', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> cheap = repository.getMoviesUnderPrice(10);

      expect(cheap, isNotEmpty);
      expect(cheap.every((movie) => movie.price <= 10), true);
      expect(repository.getMoviesUnderPrice(5), isEmpty);
    });

    // NEW (Worksheet 6): loads the real movies.json and checks every film.
    // The callback is async so it can await the loader.
    test('loadMoviesFromAsset reads every film from the bundled JSON',
        () async {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = await repository.loadMoviesFromAsset();

      expect(movies.length, 2);
      expect(movies[0].id, 'the-odyssey');
      expect(movies[0].title, 'The Odyssey');
      expect(movies[1].id, 'the-conjuring-2');
      expect(movies[1].title, 'The Conjuring 2');
      // getMovies() now returns the cached list from the load.
      expect(repository.getMovies(), movies);
    });
  });
}
