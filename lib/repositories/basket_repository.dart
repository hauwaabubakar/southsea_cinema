import 'package:southsea_cinema/models/basket_item.dart';

// Worksheet 5, Ex 4: the basket repository.
//
// Like MovieRepository, this class sits between the data and the screens.
// The difference is that it is a SINGLETON: only one copy ever exists.
//
// Why? The listing page, the basket page and the tests all need to see the
// SAME basket. If each made its own repository, a ticket added on one page
// would never appear on another.
class BasketRepository {
  // A PRIVATE constructor (the underscore makes it private to this file).
  // Code outside this file cannot call it, so nobody can create a second
  // basket by accident.
  BasketRepository._internal();

  // The one shared copy. "static" means it belongs to the class itself, so
  // any file can reach it with BasketRepository.instance.
  // "final" means it is created once and never replaced.
  static final BasketRepository instance = BasketRepository._internal();

  // The tickets in the basket. Private, so only this class can change it.
  final List<BasketItem> _items = [];

  // Lets screens READ the basket. It returns a read-only copy, so a screen
  // cannot add or remove items directly. Only the methods below can.
  // The worksheet calls this defensive copying.
  List<BasketItem> getItems() {
    return List<BasketItem>.unmodifiable(_items);
  }

  // Adds one line (a film plus a quantity) to the basket.
  void addItem(BasketItem item) {
    _items.add(item);
  }

  // Removes the line at the given position.
  // The if statement stops a crash if the position doesn't exist.
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  // Counts the total number of TICKETS, not lines.
  // Example: 2 tickets for one film and 1 for another gives 3.
  int getTotalItems() {
    int total = 0;
    for (final BasketItem item in _items) {
      total += item.quantity;
    }
    return total;
  }

  // The same count, available as a property (no brackets when you use it).
  int get totalItemCount {
    return getTotalItems();
  }

  // The basket total: every line's cost added together.
  // Tickets have no delivery fee, so the total is just the sum of the lines.
  double getTotal() {
    double sum = 0.0;
    for (final BasketItem item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  // Empties the basket, for example after checkout.
  void clear() {
    _items.clear();
  }
}
