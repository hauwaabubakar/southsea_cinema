// Worksheet 5, Ex 6: the model for the customer's profile.
//
// It holds the four things the settings form collects. Every value has a
// default, so UserSettings() on its own is a valid, empty profile.
class UserSettings {
  final String address;
  final String email;

  // The patron number is kept as text, because it is an identifier,
  // not something we do sums with.
  final String patronNumber;

  // Whether the customer wants news by email (the Switch).
  final bool receiveNewsletter;

  const UserSettings({
    this.address = '',
    this.email = '',
    this.patronNumber = '',
    this.receiveNewsletter = false,
  });
}
