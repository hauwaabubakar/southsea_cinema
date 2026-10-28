import 'package:flutter/material.dart';

class BasketButton extends StatelessWidget {
  const BasketButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_basket),
      onPressed: () {
        ModalRoute<dynamic>? modalRoute = ModalRoute.of(context);
        String currentRoute = '';

        if (modalRoute != null) {
          RouteSettings settings = modalRoute.settings;
          String? routeName = settings.name;

          if (routeName != null) {
            currentRoute = routeName;
          }
        }

        if (currentRoute != '/basket') {
          Navigator.pushNamed(context, '/basket');
        }
      },
    );
  }
}
