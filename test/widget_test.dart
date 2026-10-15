import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  group('Home page widget tests', () {
    testWidgets('home page shows title, films and booking buttons',
        (WidgetTester tester) async {
      // Build the whole app, then wait for everything to finish drawing.
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      // The app bar title.
      expect(find.text(appTitle), findsOneWidget);

      // One card per film (the card shows "Title (rating)").
      expect(find.text('The Odyssey (15)'), findsOneWidget);
      expect(find.text('The Conjuring 2 (15)'), findsOneWidget);

      // One BOOK button on each card.
      expect(find.text('BOOK'), findsNWidgets(2));
    });
  });
}
