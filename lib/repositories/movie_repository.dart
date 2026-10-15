import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    // Finds one film by its id, or returns null if there is no match.
    Movie? getMovieById(String id) {
      for (final movie in getMovies()) {
        if (movie.id == id) {
          return movie;
        }
      }
      return null;
    }

    // Returns only the films with the given age rating.
    List<Movie> getMoviesByAgeRating(String rating) {
      final List<Movie> matches = [];
      for (final movie in getMovies()) {
        if (movie.ageRating == rating) {
          matches.add(movie);
        }
      }
      return matches;
    }

    // Returns only the films that cost maxPrice or less.
    List<Movie> getMoviesUnderPrice(double maxPrice) {
      final List<Movie> matches = [];
      for (final movie in getMovies()) {
        if (movie.price <= maxPrice) {
          matches.add(movie);
        }
      }
      return matches;
    }

    return const [
      Movie(
        id: 'the-odyssey',
        title: 'The Odyssey',
        ageRating: '15',
        runtime: '2h 53m',
        description:
            'The Odyssey follows the Greek hero Odysseus on his dangerous '
            'journey home after the Trojan War, where he faces mythical '
            'creatures, gods and deadly obstacles. As he struggles to '
            'return to his wife and kingdom, his courage, loyalty and '
            'determination are tested at every turn.',
        screeningTime: 'Thursday 22 Oct 2026, 18:00 - ends at 20:53',
        price: 7.50,
        posterPath: 'assets/images/the_odyessey.jpg',
      ),
      Movie(
        id: 'the-conjuring-2',
        title: 'The Conjuring 2',
        ageRating: '15',
        runtime: '2h 14m',
        description:
            'Paranormal investigators Ed and Lorraine Warren travel to '
            'north London to help a single mother and her four children, '
            'who are being terrorised by a violent presence in their home. '
            'Based on the real Enfield poltergeist case of 1977.',
        screeningTime: 'Friday 23 Oct 2026, 20:00 - ends at 22:14',
        price: 7.50,
        posterPath: 'assets/images/the_conjuring_2.jpg',
      ),
    ];
  }
}
