import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/widgets/basket_button.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

// Worksheet 6, Ex 2: the home page now LOADS its films from
// assets/data/movies.json when it opens.
//
// It is stateful because the page changes while it loads: first a spinner,
// then either the film cards or an error message.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView> {
  // The films shown as cards. Empty until the file has been read.
  List<Movie> _movies = [];

  // True while the file is being read, so the page shows a spinner.
  bool _loading = true;

  // Filled in only if reading the file fails.
  String _errorMessage = '';

  // Called once when the page is created.
  // It stays synchronous: it only STARTS the loading method below.
  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  // Future<void> means "this takes time and gives back nothing". It updates
  // the page through setState instead.
  Future<void> _loadMovies() async {
    // try runs code that might fail. If anything inside throws an error,
    // Dart jumps to catch, and "error" holds what went wrong.
    try {
      final MovieRepository repository = MovieRepository();
      // await waits for the file to be read before moving on.
      final List<Movie> movies = await repository.loadMoviesFromAsset();

      // mounted is true while this page is still on screen. While we were
      // waiting, the customer may have left the page, and updating a page
      // that is gone would cause an error.
      if (!mounted) {
        return;
      }
      setState(() {
        _movies = movies;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      // Show what went wrong instead of a spinner that never ends.
      setState(() {
        _errorMessage = 'Could not load the films: $error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // "final Widget body;" declares the variable without a value yet. Each
    // branch below gives it exactly one, and Dart reports an error if a
    // branch forgets.
    final Widget body;
    if (_loading) {
      // Still reading the file: show a spinning circle.
      body = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage.isNotEmpty) {
      // Reading failed: show the message.
      body = Center(child: Text(_errorMessage));
    } else {
      // Loaded: one MovieCard per film, built as each scrolls into view.
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: _movies[index]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
        // The basket icon on the right of the app bar.
        actions: const [
          BasketButton(),
        ],
      ),
      drawer: const NavDrawer(),
      body: body,
    );
  }
}