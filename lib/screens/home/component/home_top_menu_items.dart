import 'package:auction/screens/dashboard/dashboaed_screen.dart';
import 'package:auction/screens/my_items/my_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu_button_widget.dart';

class HomeTopMenuItems extends StatelessWidget {
  const HomeTopMenuItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            MenuButton_Widget(
                name: 'Dashboard',
                icon: Icons.dashboard,
                press: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => DashBoardScreen(),
                    ),
                  );
                }),
            const SizedBox(
              width: 10.0,
            ),
            MenuButton_Widget(
                name: 'My Items',
                icon: Icons.view_day,
                press: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => MyItemsScreen(),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
