import 'package:southsea_cinema/models/movie.dart';

// Worksheet 5, Ex 4: the model for ONE LINE in the basket.
//
// A Movie describes a film in the catalogue (title, price, poster...).
// A BasketItem describes what the customer chose: which film, and how many
// tickets. It holds a Movie inside it. The worksheet calls this composition.
class BasketItem {
  // The film this line is for.
  final Movie movie;

  // How many tickets for that film.
  final int quantity;

  // Both values are required, so a line can't exist half-filled.
  // Both are final, so a line can't be changed once it is created.
  const BasketItem({
    required this.movie,
    required this.quantity,
  });

  // The cost of this one line: ticket price multiplied by the quantity.
  // Example: 2 tickets at £7.50 gives £15.00.
  double get lineTotal {
    return movie.price * quantity;
  }
}
