import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:southsea_cinema/models/movie.dart';

// The one place the film data comes from.
class MovieRepository {
  // Worksheet 6: holds the most recently loaded list. It starts as null
  // (the ? means "a list or null") because nothing has been loaded yet.
  List<Movie>? _cachedMovies;

  List<Movie> getMovies() {
    // Worksheet 6: if a load has already finished, return that list.
    // We copy the field into a local variable first. After the != null
    // check, Dart knows the local copy can't be null, so it can be
    // returned as a List<Movie>.
    final List<Movie>? cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return cachedMovies;
    }

    // Otherwise, the fixed list typed in below (kept so the earlier
    // lookup tests still work without loading a file).
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

  // Worksheet 6: reads the films from the bundled JSON file.
  //
  // Future<List<Movie>> means "a list of films that arrives later".
  // assetPath is an optional named parameter with a default, so
  // loadMoviesFromAsset() reads assets/data/movies.json, while a test
  // could pass a different path.
  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    // rootBundle reads files listed under assets: in pubspec.yaml.
    // await waits for the text before moving on.
    final String jsonString = await rootBundle.loadString(assetPath);

    // jsonDecode turns JSON text into Dart lists and maps. It can't know
    // what the file holds, so we check it's a list with "as List<dynamic>".
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    final List<Movie> loadedMovies = [];

    // Each item is one JSON object, so check it's a map, then convert it.
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(itemMap);
      loadedMovies.add(movie);
    }

    // Remember the list, so getMovies() returns it from now on.
    _cachedMovies = loadedMovies;
    return loadedMovies;
  }
}
