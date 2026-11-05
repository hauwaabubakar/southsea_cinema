import 'package:southsea_cinema/models/basket_item.dart';

// Like MovieRepository, this class sits between the data and the screens.
//SINGLETON: only one copy ever exists.

// Why? The listing page, the basket page and the tests all need to see the
// SAME basket. If each made its own repository, a ticket added on one page
// would never appear on another.
class BasketRepository {
  //only private so no other file outside can call it
  //resulting in creating a second basket (yikes!!)
  BasketRepository._internal();

  // The one shared copy. "static" means it belongs to the class itself, so
  // any file can reach it with BasketRepository.instance.
  // "final" means it is created once and never replaced.
  static final BasketRepository instance = BasketRepository._internal();

  // a service charge which only applies when basket not empty
  //also added to verey order with a ticket in it
  static const double serviceChargeAmount = 4.00;
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

  // The cost of all the tickets: every line's cost added together,
  // before the service charge.
  double getSubtotal() {
    double sum = 0.0;
    for (final BasketItem item in _items) {
      sum += item.lineTotal;
    }
    return sum;
  }

  // The service charge: nothing for an empty basket, otherwise the flat
  // amount above.
  double getServiceCharge() {
    if (_items.isEmpty) {
      return 0.0;
    }
    return serviceChargeAmount;
  }

  // The final amount the customer pays: tickets plus service charge.
  double getTotalDue() {
    return getSubtotal() + getServiceCharge();
  }

  // Empties the basket, for example after buying the tickets.
  void clear() {
    _items.clear();
  }
}
