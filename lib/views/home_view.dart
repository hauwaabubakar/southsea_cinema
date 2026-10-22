import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class HomeView extends StatelessWidget {
  // A widget that doesn't manage its own changing information.
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ask the repository for the list of films.
    final MovieRepository repository = MovieRepository();
    final List<Movie> movies = repository.getMovies();

    return Scaffold(
      // skeleton of the app's screen
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      // Builds one MovieCard per film, only as each one scrolls into view.
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: movies.length, // The number of films to display.
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}
