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
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        width: double.infinity,
        color: cinemaBackground,
        padding: const EdgeInsets.all(16),
        // Lets the page scroll if it is taller than the screen.
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and age rating, taken from the film.
              Text(
                '${movie.title.toUpperCase()} (${movie.ageRating})',
                style: cinemaHeaderStyle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Southsea Cinema Room',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 8),
              Text(
                movie.screeningTime,
                style: const TextStyle(color: cinemaFontMuted),
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
              const SizedBox(height: 16),
              const Text(
                'Select Quantities (Up to 5 in total)',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tickets',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // LayoutBuilder gives the available width, so the layout
              // can differ on narrow (phone) and wide screens.
              LayoutBuilder(
                builder: (context, constraints) {
                  // The ticket quantity dropdown. Picking a value stores it
                  // in _tickets using setState, so the screen rebuilds.
                  final dropdown = DropdownMenu<int>(
                    initialSelection: 0,
                    width: 100,
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
                  // Price label, using the getter from the Movie model.
                  final price = Text(
                    'Adult (${movie.formattedPrice})',
                    style: const TextStyle(color: cinemaFontWhite),
                  );

                  // Wide window: dropdown and price side by side.
                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        dropdown,
                        const SizedBox(width: 16),
                        price,
                      ],
                    );
                  } else {
                    // Narrow (phone): price below the dropdown.
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dropdown,
                        const SizedBox(height: 8),
                        price,
                      ],
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
              // Empty at first, then shows _message.
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
