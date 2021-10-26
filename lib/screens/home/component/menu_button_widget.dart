import 'package:auction/const/app_colors.dart';
import 'package:flutter/material.dart';

class MenuButton_Widget extends StatelessWidget {
  const MenuButton_Widget({
    Key? key,
    required this.name,
    required this.icon,
    required this.press,
  }) : super(key: key);
  final String name;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
        child: GestureDetector(
      onTap: press,
      child: Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width / 2,
        decoration: const BoxDecoration(
            color: AppColorsConst.deep_orrange,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            Text(
              name,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    ));
  }
}
