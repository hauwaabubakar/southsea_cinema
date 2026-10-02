// Imports: Flutter's Material widgets, our shared colours/styles, and the drawer.
import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

// The widget (the fixed configuration). It is Stateful because the page
// has data that changes: the chosen ticket count and the feedback message.
class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  // Tells Flutter which State class goes with this widget.
  @override
  State<MovieListing> createState() {
    return _MovieListingState();
  }
}

// The State (the data that changes + the build method).
// The _ makes this class private to this file.
class _MovieListingState extends State<MovieListing> {
  int _tickets = 0; // currently selected quantity (starts at 0)
  String _message = ''; // feedback text shown under the button

  @override
  Widget build(BuildContext context) {
    // Scaffold = basic page layout: app bar, drawer, body.
    return Scaffold(
      // Top bar, styled with the shared constants (same as the home page).
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      // The side navigation menu.
      drawer: const NavDrawer(),
      // Container = a box with a colour and padding (Exercise 1).
      body: Container(
        width: double.infinity, // fill the full width
        color: cinemaBackground,
        padding: const EdgeInsets.all(16),
        // Lets the page scroll if it is taller than the screen.
        child: SingleChildScrollView(
          // Column = stack children vertically (Exercise 2).
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // align left
            children: [
              // Title. copyWith reuses the header style but makes it bigger.
              Text(
                'THE ODYSSEY (15)',
                style: cinemaHeaderStyle.copyWith(fontSize: 28),
              ),
              // SizedBox = an empty gap of fixed size.
              const SizedBox(height: 16),
              // Muted grey details: venue, date/time, runtime.
              const Text(
                'Southsea Cinema Room',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 8),
              const Text(
                'Thursday 3 Oct 2026, 19:30 - ends at 22:22',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 8),
              const Text(
                'Runtime: 2h 53m',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 16),
              // Film description. Neighbouring strings are joined by Dart.
              const Text(
                'The Odyssey follows the Greek hero Odysseus on his dangerous '
                'journey home after the Trojan War, where he faces mythical '
                'creatures, gods and deadly obstacles. As he struggles to '
                'return to his wife and kingdom, his courage, loyalty and '
                'determination are tested at every turn.',
                style: TextStyle(color: cinemaFontWhite),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Quantities (Up to 5 in total)',
                style: TextStyle(color: cinemaFontMuted),
              ),
              const SizedBox(height: 16),
              // Bold "Tickets" heading.
              const Text(
                'Tickets',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Exercise 6: LayoutBuilder gives us the available width,
              // so we can change the layout on narrow vs wide screens.
              LayoutBuilder(
                builder: (context, constraints) {
                  // Exercise 3: the dropdown. Picking a value stores it in
                  // _tickets using setState, so the screen rebuilds.
                  final dropdown = DropdownMenu<int>(
                    initialSelection: 0,
                    width: 100,
                    // int? means the value could be null, so we check first.
                    onSelected: (int? value) {
                      if (value != null) {
                        setState(() {
                          _tickets = value;
                        });
                      }
                    },
                    // The options: 0 to 5 tickets.
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(value: 0, label: '0'),
                      DropdownMenuEntry(value: 1, label: '1'),
                      DropdownMenuEntry(value: 2, label: '2'),
                      DropdownMenuEntry(value: 3, label: '3'),
                      DropdownMenuEntry(value: 4, label: '4'),
                      DropdownMenuEntry(value: 5, label: '5'),
                    ],
                  );
                  // The price label shown next to / below the dropdown.
                  const price = Text(
                    'Adult (£7.50)',
                    style: TextStyle(color: cinemaFontWhite),
                  );

                  // Wide window: Row (dropdown and price side by side).
                  if (constraints.maxWidth > 600) {
                    return Row(
                      children: [
                        dropdown,
                        const SizedBox(width: 16),
                        price,
                      ],
                    );
                  } else {
                    // Narrow (phone): Column (price below the dropdown).
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
              // Exercise 4: the "Add to order" button.
              ElevatedButton(
                // Exercise 5: styled with the brand colours from constants.
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                  shape: const RoundedRectangleBorder(), // square corners
                ),
                // Runs when pressed: builds the feedback message and
                // calls setState so the Text below updates.
                onPressed: () {
                  setState(() {
                    if (_tickets == 0) {
                      _message = 'Please select at least one ticket.';
                    } else {
                      _message =
                          'Added $_tickets ticket(s) for The Odyssey to your order.';
                    }
                  });
                },
                child: const Text('ADD TO ORDER'),
              ),
              const SizedBox(height: 8),
              // Feedback text: empty at first, then shows _message.
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
