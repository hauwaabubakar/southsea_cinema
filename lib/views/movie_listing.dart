import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() {
    return _MovieListingState();
  }
}

class _MovieListingState extends State<MovieListing> {
  int _tickets = 0;
  String _message = '';

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE ODYSSEY (15)',
                style: cinemaHeaderStyle.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
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
              const Text(
                'Tickets',
                style: TextStyle(
                  color: cinemaFontWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  DropdownMenu<int>(
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
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Adult (£7.50)',
                    style: TextStyle(color: cinemaFontWhite),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cinemaBrand,
                  foregroundColor: cinemaFontWhite,
                  shape: const RoundedRectangleBorder(),
                ),
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
