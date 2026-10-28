import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/basket_screen.dart';
import 'package:southsea_cinema/views/settings_screen.dart';

// import 'package:southsea_cinema/views/movie_listing.dart';
// import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  runApp(const SouthseaCinemaApp());
}

class SouthseaCinemaApp extends StatelessWidget {
  const SouthseaCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Southsea Cinema & Arts Centre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: cinemaBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
        // Exercise 1: one shared app bar style for every page.
        appBarTheme: const AppBarTheme(
          backgroundColor: cinemaSurface,
          iconTheme: IconThemeData(color: cinemaBrand),
          titleTextStyle: cinemaHeaderStyle,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        // Exercise 3: named routes for the basket and settings pages.
        '/basket': (context) {
          return const BasketScreen();
        },
        '/settings': (context) {
          return const SettingsScreen();
        },

        // '/listing': (context) =>
        //   MovieListing(movie: MovieRepository().getMovies().first),
      },
    );
  }
}
