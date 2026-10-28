import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

// Worksheet 5, Ex 5: the basket page. It reads the shared BasketRepository
// and lets the customer remove tickets or check out.
//
// It is stateful because removing an item or checking out changes what is
// shown, and setState tells Flutter to redraw.
class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  // Shown after checkout. Checkout empties the basket, so without this the
  // customer would only see "Your basket is empty" with no confirmation.
  String _confirmationMessage = '';

  // What the page shows when the basket has nothing in it.
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: cinemaFontMuted),
        ),
      ),
    );
  }

  // One row in the basket: quantity and film on the left, cost underneath,
  // and a delete icon on the right.
  Widget _buildLineItem(BasketRepository basket, BasketItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Expanded gives the text the space left over, so a long film
          // title wraps and the delete icon always stays visible.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.movie.title}',
                  style: const TextStyle(
                    color: cinemaFontWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // lineTotal comes from BasketItem: price x quantity.
                Text(
                  '£${item.lineTotal.toStringAsFixed(2)}',
                  style: const TextStyle(color: cinemaFontMuted),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              // Remove this line from the basket, then redraw the page.
              setState(() {
                basket.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  // A reusable row with a label on the left and a value on the right.
  // The final total is shown bold and larger (emphasise: true).
  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(
        color: cinemaFontWhite,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
    } else {
      style = const TextStyle(color: cinemaFontMuted);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        // Pushes the label to the far left and the value to the far right.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  // What the page shows when the basket has tickets in it.
  // The widgets are collected into a list, then returned in one Column.
  Widget _buildBasketList(BasketRepository basket, List<BasketItem> items) {
    final List<Widget> children = [];

    children.add(const Text('Your basket', style: cinemaHeaderStyle));
    children.add(const SizedBox(height: 16));

    // One row for every line in the basket.
    for (int index = 0; index < items.length; index++) {
      final BasketItem item = items[index];
      children.add(_buildLineItem(basket, item, index));
    }

    // The summary: how many tickets, and what they cost in total.
    children.add(const SizedBox(height: 24));
    children.add(
      _buildTotalRow(
        'Tickets',
        '${basket.getTotalItems()}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total to pay',
        '£${basket.getTotal().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));

    // Checkout empties the basket and stores a thank-you message.
    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Checkout',
          onPressed: () {
            setState(() {
              basket.clear();
              _confirmationMessage = 'Thanks, your tickets are booked';
            });
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ask the shared basket for its contents every time the page is drawn.
    final BasketRepository basket = BasketRepository.instance;
    final List<BasketItem> items = basket.getItems();

    // Decide what to show: the empty message, or the list of tickets.
    final Widget content;
    if (items.isEmpty) {
      // After checkout the basket is empty, but we still show the thank-you
      // message under the empty-basket text.
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(
                color: cinemaBrandLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(basket, items);
    }

    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      // Scrolls, so long baskets and the Checkout button stay reachable.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
