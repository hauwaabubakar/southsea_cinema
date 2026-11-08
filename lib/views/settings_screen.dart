import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

// Worksheet 6, Ex 4: the names (keys) the saved values are stored under.
// Each saved value needs a stable key, so we can find it again later.
// Constants like these live at the top of the file, outside the class.
const String prefAddress = 'user_address';
const String prefEmail = 'user_email';
const String prefPatronNumber = 'user_patron_number';
const String prefNewsletter = 'user_newsletter';

// Worksheet 5, Ex 6: the "My Settings" form on the /settings page.
// Worksheet 6, Ex 4: it now REMEMBERS the details between visits.
//
// It is stateful because the page changes while the customer uses it: the
// form fills in when it loads, the switch flips, and a confirmation message
// appears after saving.
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

  // The last profile that was saved (or loaded). Cancel puts the form back
  // to these.
  UserSettings _savedSettings = const UserSettings();

  // Feedback shown after the customer presses SAVE SETTINGS.
  String _confirmationMessage = '';

  // Called once when the page is first created: set the controllers up,
  // then start loading any saved details.
  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();
    // Start loading the saved values. This stays synchronous: it only
    // STARTS the loading method, which does the awaiting.
    _loadSettings();
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

  // Worksheet 6, Ex 4: reads the saved values and fills the form.
  // Future<void> means "this takes time and gives back nothing".
  Future<void> _loadSettings() async {
    // Creating the store does not need await. Each READ does, because
    // reading from storage takes time.
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? savedAddress = await prefs.getString(prefAddress);
    final String? savedEmail = await prefs.getString(prefEmail);
    final String? savedPatronNumber = await prefs.getString(prefPatronNumber);
    final bool? savedNewsletter = await prefs.getBool(prefNewsletter);

    // The ? means "a value, or null". A value is null when nothing has been
    // saved under that key yet (the first time the page is ever opened).
    // Each check below uses the saved value, or an empty default.
    String address = '';
    if (savedAddress != null) {
      address = savedAddress;
    }

    String email = '';
    if (savedEmail != null) {
      email = savedEmail;
    }

    String patronNumber = '';
    if (savedPatronNumber != null) {
      patronNumber = savedPatronNumber;
    }

    bool newsletter = false;
    if (savedNewsletter != null) {
      newsletter = savedNewsletter;
    }

    // mounted is true while this page is still on screen. While we were
    // waiting for storage, the customer may have left the page.
    if (!mounted) {
      return;
    }

    // Put the saved values into the form. _savedSettings is updated too,
    // so Cancel returns to the loaded values (a cinema addition).
    setState(() {
      _addressController.text = address;
      _emailController.text = email;
      _patronNumberController.text = patronNumber;
      _receiveNewsletter = newsletter;
      _savedSettings = UserSettings(
        address: address,
        email: email,
        patronNumber: patronNumber,
        receiveNewsletter: newsletter,
      );
    });
  }

  // Runs when SAVE SETTINGS is pressed.
  // It is now async, because writing to storage takes time.
  Future<void> _saveSettings() async {
    // .text reads what was typed. .trim() removes extra spaces at the ends.
    final String address = _addressController.text.trim();
    final String email = _emailController.text.trim();
    final String patronNumber = _patronNumberController.text.trim();

    // Write each value under its key. await waits for each write to
    // finish before moving on.
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setString(prefAddress, address);
    await prefs.setString(prefEmail, email);
    await prefs.setString(prefPatronNumber, patronNumber);
    await prefs.setBool(prefNewsletter, _receiveNewsletter);

    // Gather the values into one UserSettings object.
    final UserSettings settings = UserSettings(
      address: address,
      email: email,
      patronNumber: patronNumber,
      receiveNewsletter: _receiveNewsletter,
    );

    // The customer may have left the page while we were saving.
    if (!mounted) {
      return;
    }

    // Show the confirmation. It now appears AFTER the saves have finished.
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
