import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'address_input.dart';
import 'localizations.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final firebaseUser = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    DocumentSnapshot snapshot = await User.getReference(firebaseUser).get();
    return User(firebaseUser, snapshot.data);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).mainTitle),
      ),
      body: Center(
        child: RaisedButton(
            child: Text(BallotLocalizations.of(context).signInWithGoogle,
                style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              _signInWithGoogle().then((user) {
                var route = MaterialPageRoute(
                  builder: (context) => AddressInputPage(user: user),
                );
                Navigator.of(context).pushReplacement(route);
              });
            }),
      ),
    );
  }
}
