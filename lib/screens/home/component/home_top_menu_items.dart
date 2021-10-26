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
          children:  [
            MenuButton_Widget(name: 'Dashboard', icon: Icons.dashboard, press: (){}),
            const SizedBox(width: 10.0,),
            MenuButton_Widget(name: 'My Items', icon: Icons.view_day, press: (){}),
          ],
        ),
      ),
    );
  }
}