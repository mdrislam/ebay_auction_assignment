import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleSignInButton extends StatelessWidget {
   GoogleSignInButton({Key? key, required this.press}) : super(key: key);
  VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      child: OutlineButton.icon(
        label: const Text(
          'Sign In With Google',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        highlightedBorderColor: Colors.black,
        borderSide: const BorderSide(color: Colors.black),
        textColor: Colors.black,
        icon: const FaIcon(
          FontAwesomeIcons.google,
          color: Colors.red,
        ),
        onPressed: press,
      ),
    );
  }
}
