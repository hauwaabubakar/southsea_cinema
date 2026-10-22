import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

// The page for ONE film. The film is passed in when the page is opened.
class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({super.key, required this.movie});

  @override
  State<MovieListing> createState() {
    return _MovieListingState();
  }
}

class _MovieListingState extends State<MovieListing> {
  int _tickets = 0; // currently selected quantity
  String _message = ''; // feedback text under the button

  @override
  Widget build(BuildContext context) {
    // widget.movie reads the film stored in the MovieListing class above.
    final Movie movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      // Scrolls if the content is taller than the screen.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // The lighter box that holds the film details.
        child: Container(
          width: double.infinity,
          color: cinemaSurface,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${movie.title.toUpperCase()} (${movie.ageRating})',
                style: cinemaHeaderStyle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              // The poster, loaded from the path stored in the film.
              Image.asset(
                movie.posterPath,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Text(
                'Southsea Cinema Room',
                style: TextStyle(color: cinemaFontWhite),
              ),
              const SizedBox(height: 8),
              Text(
                movie.screeningTime,
                style: const TextStyle(color: cinemaFontWhite),
              ),
              const SizedBox(height: 8),
              Text(
                'Runtime: ${movie.runtime}',
                style: const TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 16),
              Text(
                movie.description,
                style: const TextStyle(color: cinemaFontWhite),
              ),
              const SizedBox(height: 24),
              // LayoutBuilder gives the available width, so the layout can
              // differ on narrow (phone) and wide screens.
              LayoutBuilder(
                builder: (context, constraints) {
                  final label = Text(
                    'Tickets (${movie.formattedPrice} each)',
                    style: const TextStyle(color: cinemaFontWhite),
                  );
                  // Picking a value stores it in _tickets with setState,
                  // so the screen rebuilds.
                  final dropdown = DropdownMenu<int>(
                    initialSelection: 0,
                    width: 120,
                    onSelected: (int? value) {
                      if (value != null) {
                        setState(() {
                          _tickets = value;
                        });
                      }
                    },
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 0, label: '0'),
                      DropdownMenuEntry(value: 1, label: '1'),
                      DropdownMenuEntry(value: 2, label: '2'),
                      DropdownMenuEntry(value: 3, label: '3'),
                      DropdownMenuEntry(value: 4, label: '4'),
                      DropdownMenuEntry(value: 5, label: '5'),
                    ],
                  );

                  if (constraints.maxWidth > 600) {
                    // Wide: keep the label and dropdown together.
                    return Row(
                      children: [
                        label,
                        const SizedBox(width: 24),
                        dropdown,
                      ],
                    );
                  } else {
                    // Narrow (phone): label left, dropdown right.
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [label, dropdown],
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                  shape: const RoundedRectangleBorder(),
                ),
                // Builds the feedback message, then setState redraws.
                onPressed: () {
                  setState(() {
                    if (_tickets == 0) {
                      _message = 'Please select at least one ticket.';
                    } else {
                      _message =
                          'Added $_tickets ticket(s) for ${movie.title} to your order.';
                    }
                  });
                },
                child: const Text('ADD TO ORDER'),
              ),
              const SizedBox(height: 8),
              Text(
                _message,
                style: const TextStyle(color: cinemaBrandLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
