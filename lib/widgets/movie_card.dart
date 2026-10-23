import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

// A reusable card that shows ONE film on the home page.
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title in the brand colour, with the age rating small and muted.
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: movie.title,
                  style: const TextStyle(
                    color: cinemaBrand,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' (${movie.ageRating})',
                  style: const TextStyle(
                    color: cinemaFontMuted,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Poster on the left, synopsis on the right.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                movie.posterPath,
                width: 120,
                height: 180,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  movie.description,
                  style: const TextStyle(color: cinemaFontWhite),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'BOOK TICKETS',
            style: TextStyle(color: cinemaFontWhite),
          ),
          const SizedBox(height: 12),
          // Screening time on the left, booking button on the right.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  movie.screeningTime,
                  style: const TextStyle(color: cinemaFontWhite),
                ),
              ),
              const SizedBox(width: 12),
              PrimaryButton(
                label: 'BOOK NOW',
                // Opens the listing page for THIS card's film.
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MovieListing(movie: movie);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}