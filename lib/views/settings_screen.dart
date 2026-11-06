import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

// Worksheet 5, Ex 6: the "My Settings" form on the /settings page.
//
// It is stateful because the page changes while the customer uses it: the
// switch flips and a confirmation message appears after saving.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  // One controller per text box. A controller holds the text the customer
  // types, so the code can read it. "late" means each one is given a value
  // in initState() before it is ever used.
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _patronNumberController;

  // The current position of the "Receive news by email" switch.
  bool _receiveNewsletter = false;

  // The last profile that was saved. Cancel puts the form back to these.
  UserSettings _savedSettings = const UserSettings();

  // Feedback shown after the customer presses SAVE SETTINGS.
  String _confirmationMessage = '';

  // Called once when the page is first created: set the controllers up.
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();
  }

  // Called when the page is removed. Controllers use system resources, so
  // they are released here to stop memory being wasted.
  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  // Runs when SAVE SETTINGS is pressed.
  // Not an override, so there is no @override above it.
  void _saveSettings() {
    // .text reads what was typed. .trim() removes extra spaces at the ends.
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNumber = _patronNumberController.text.trim();

    // Gather the values into one UserSettings object.
    final UserSettings settings = UserSettings(
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveNewsletter: _receiveNewsletter,
    );

    // Show the confirmation. setState makes Flutter redraw the page.
    setState(() {
      _savedSettings = settings;
      _confirmationMessage = 'Settings saved';
    });
  }

  // Runs when CANCEL is pressed: throw away anything typed since the last
  // save and put the saved values back into the form.
  void _cancelChanges() {
    setState(() {
      _addressController.text = _savedSettings.address;
      _emailController.text = _savedSettings.email;
      _patronNumberController.text = _savedSettings.patronNumber;
      _receiveNewsletter = _savedSettings.receiveNewsletter;
      _confirmationMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      // Scrolls, so the page stays usable when the keyboard slides up and
      // takes space on a phone.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Settings',
              style: TextStyle(
                color: cinemaFontWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Address. maxLines: 3 lets the box hold a multi-line address.
            // The X button on the right clears the box.
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Address',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _addressController.clear();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email. The keyboard type shows the @ key on phones.
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email Address',
              ),
            ),
            const SizedBox(height: 16),

            // Patron number. The number keyboard shows on phones.
            TextField(
              controller: _patronNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Patron Number',
              ),
            ),
            const SizedBox(height: 16),

            // A small muted heading above the switch.
            const Text(
              'Preferences',
              style: TextStyle(color: cinemaFontMuted),
            ),
            const SizedBox(height: 8),

            // The newsletter toggle: text on the left, switch on the right.
            // Expanded gives the text the space left over.
            Row(
              children: [
                const Expanded(
                  child: Text('Receive news by email'),
                ),
                Switch(
                  value: _receiveNewsletter,
                  // onChanged gives the new true/false value when flipped.
                  onChanged: (bool value) {
                    setState(() {
                      _receiveNewsletter = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // CANCEL (dark) and SAVE SETTINGS (brand blue), side by side.
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cinemaSurface,
                    foregroundColor: cinemaFontWhite,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: _cancelChanges,
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  label: 'SAVE SETTINGS',
                  onPressed: _saveSettings,
                ),
              ],
            ),

            // The ... (spread) operator adds the spacer and message to the
            // list only when the message isn't empty.
            if (_confirmationMessage.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                _confirmationMessage,
                style: const TextStyle(
                  color: cinemaBrandLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}