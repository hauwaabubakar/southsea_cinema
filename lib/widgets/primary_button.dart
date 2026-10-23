import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';

// One button style for the whole app: brand colour, squared corners.
class PrimaryButton extends StatelessWidget {
  final String label; // button's text passed in
  final VoidCallback onPressed; //runs when tapped

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cinemaBrand,
        foregroundColor: cinemaFontWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, //squared corners
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}