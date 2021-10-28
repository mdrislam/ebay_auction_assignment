import 'package:auction/const/app_colors.dart';
import 'package:flutter/material.dart';

class DashBoard_Menu_Widget extends StatelessWidget {
  const DashBoard_Menu_Widget({
    Key? key,
    required this.name,
    required this.data,

  }) : super(key: key);
  final String name;
  final String data;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
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
              Text(
                data,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
        ));
  }
}
