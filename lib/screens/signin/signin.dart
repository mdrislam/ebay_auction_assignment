import 'package:auction/components/google_signin.dart';
import 'package:auction/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              width: 170,
              child: const Text(
                'Welcome to eBay Auction',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Spacer(),
          GoogleSignInButton(press: () {
            print('press');
            signInWithGoogle(context);
          }),
          const SizedBox(
            height: 12,
          ),
          const Text(
            "Loging to Continue",
            style: TextStyle(fontSize: 16),
          ),
          const Spacer()
        ],
      ),
    );
  }

  Future signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    await _auth.signInWithCredential(credential);

    if (_auth.currentUser!.uid.isEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (BuildContext context) => const HomeScreen()),
          (route) => false);
    }
  }
}
