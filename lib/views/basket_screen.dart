import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

// Worksheet 5, Ex 5: the basket page ("MY ORDER"). It reads the shared
// BasketRepository and lets the customer remove tickets or buy them.
//
// It is stateful because removing an item or buying changes what is
// shown, and setState tells Flutter to redraw.
class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State<BasketScreen> {
  // Column widths, shared by the heading row and every ticket row so the
  // three columns (Item, Details, Price) line up exactly.
  static const double _itemColumnWidth = 80.0;
  static const double _priceColumnWidth = 64.0;
  static const double _deleteColumnWidth = 56.0;

  // Shown after buying. Buying empties the basket, so without this the
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

  // The heading row: Item, Details and Price, in bold white.
  Widget _buildHeadingRow() {
    const TextStyle headingStyle = TextStyle(
      color: cinemaFontWhite,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: _itemColumnWidth,
            child: Text('Item', style: headingStyle),
          ),
          // Details takes all the space that is left over.
          Expanded(
            child: Text('Details', style: headingStyle),
          ),
          SizedBox(
            width: _priceColumnWidth,
            child: Text(
              'Price',
              style: headingStyle,
              textAlign: TextAlign.right,
            ),
          ),
          // An empty box the same width as the delete button column.
          SizedBox(width: _deleteColumnWidth),
        ],
      ),
    );
  }

  // One row in the basket: "2 Tickets" in blue, the details, the price,
  // and a blue delete button with a white bin icon.
  Widget _buildLineItem(BasketRepository basket, BasketItem item, int index) {
    // "1 Ticket" for one, "2 Tickets" for more.
    final String ticketWord;
    if (item.quantity == 1) {
      ticketWord = 'Ticket';
    } else {
      ticketWord = 'Tickets';
    }

    // Quantity and ticket type on the first line, then the film in capitals,
    // its screening time and the room, as in the worksheet screenshot.
    final String details = '${item.quantity} Standard\n'
        '${item.movie.title.toUpperCase()}, '
        '${item.movie.screeningTime}, Southsea Cinema Room';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        // Line everything up at the top of the row.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _itemColumnWidth,
            child: Text(
              '${item.quantity} $ticketWord',
              style: const TextStyle(
                color: cinemaBrand,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              details,
              style: const TextStyle(color: cinemaFontWhite, fontSize: 16),
            ),
          ),
          SizedBox(
            width: _priceColumnWidth,
            // lineTotal comes from BasketItem: price x quantity.
            child: Text(
              '£${item.lineTotal.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: cinemaFontWhite, fontSize: 16),
            ),
          ),
          SizedBox(
            width: _deleteColumnWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              // The Container paints the brand-blue square behind the icon.
              child: Container(
                color: cinemaBrand,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: cinemaFontWhite,
                  ),
                  onPressed: () {
                    // Remove this line from the basket, then redraw.
                    setState(() {
                      basket.removeItem(index);
                    });
                  },
                ),
              ),
            ),
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
        fontSize: 20,
      );
    } else {
      style = const TextStyle(color: cinemaFontWhite, fontSize: 16);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
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

    children.add(const Text('MY ORDER', style: cinemaHeaderStyle));
    children.add(_buildHeadingRow());

    // One row for every line in the basket.
    for (int index = 0; index < items.length; index++) {
      final BasketItem item = items[index];
      children.add(_buildLineItem(basket, item, index));
    }

    // The summary: the service charge, then the total due.
    children.add(const SizedBox(height: 16));
    children.add(
      _buildTotalRow(
        'Service Charge',
        '£${basket.getServiceCharge().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total Due',
        '£${basket.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));

    // The two buttons: one at each end of the row.
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryButton(
            label: 'UPDATE ORDER',
            onPressed: () {
              // Go back to the film list so the customer can change their
              // tickets. popUntil removes pages until the first one (the
              // home page) is showing.
              Navigator.popUntil(context, (Route<dynamic> route) {
                return route.isFirst;
              });
            },
          ),
          PrimaryButton(
            label: 'BUY TICKETS',
            onPressed: () {
              // Empty the basket and store a thank-you message.
              // Saved bookings come in a later worksheet.
              setState(() {
                basket.clear();
                _confirmationMessage = 'Thanks, your tickets are booked';
              });
            },
          ),
        ],
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
      // After buying, the basket is empty, but we still show the thank-you
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
      // Scrolls, so long baskets and the buttons stay reachable.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: content,
      ),
    );
  }
}
