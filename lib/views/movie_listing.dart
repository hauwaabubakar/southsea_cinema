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
  int _tickets = 1;

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
        color: cinemaSurface,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'The Odyssey',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text('Runtime: 2h 53m'),
                SizedBox(width: 16),
                Text('Rating: 15'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'The Odyssey follows the Greek hero Odysseus on his dangerous '
              'journey home after the Trojan War, where he faces mythical '
              'creatures, gods and deadly obstacles. As he struggles to return '
              'to his wife and kingdom, his courage, loyalty and determination '
              'are tested at every turn.',
            ),
            const SizedBox(height: 16),
            DropdownMenu<int>(
              initialSelection: 1,
              label: const Text('Tickets'),
              onSelected: (int? value) {
                if (value != null) {
                  setState(() {
                    _tickets = value;
                  });
                }
              },
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 1, label: '1'),
                DropdownMenuEntry(value: 2, label: '2'),
                DropdownMenuEntry(value: 3, label: '3'),
                DropdownMenuEntry(value: 4, label: '4'),
                DropdownMenuEntry(value: 5, label: '5'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
