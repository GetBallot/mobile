import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'address_input.dart';
import 'localizations.dart';
import 'user.dart';
import 'voting_profile.dart';

class LoginPage extends StatelessWidget {
  static const String routeName = "/login";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Widget onLogin(context, User user) {
    if (user != null && user.address != null) {
      return VotingProfile(firebaseUser: user.firebaseUser);
    } else {
      return AddressInputPage(
          firebaseUser: user.firebaseUser,
          firstTime: true,
          hint: BallotLocalizations.of(context).votingAddressLabel);
    }
  }

  static Future<FirebaseUser> _logOut(auth, googleSignIn) async {
    await auth.signOut();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    return null;
  }

  static Widget createLogoutButton(context, auth, googleSignIn) {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: () {
        _logOut(auth, googleSignIn).then((_) =>
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName));
      },
    );
  }

  Future<User> _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final firebaseUser = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    DocumentSnapshot snapshot = await User.getAddressRef(firebaseUser).get();
    return User(firebaseUser, snapshot);
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
                  builder: (context) => LoginPage.onLogin(context, user),
                );
                Navigator.of(context).pushReplacement(route);
              });
            }),
      ),
    );
  }
}
