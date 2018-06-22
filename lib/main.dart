import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localizations.dart';
import 'login.dart';
import 'user.dart';

void main() => runApp(Ballot());

class Ballot extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser == null) {
      return null;
    }

    DocumentSnapshot snapshot = await User.getAddressRef(firebaseUser).get();

    return User(firebaseUser, snapshot);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      onGenerateTitle: (BuildContext context) =>
          BallotLocalizations.of(context).mainTitle,
      localizationsDelegates: [
        const BallotLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      // Watch out: MaterialApp creates a Localizations widget
      // with the specified delegates. BallotLocalizations.of()
      // will only find the app's Localizations widget if its
      // context is a child of the app.
      home: FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          User user = snapshot.data;
          if (user == null) {
            return LoginPage();
          } else {
            return LoginPage.onLogin(context, user);
          }
        },
      ),
      routes: <String, WidgetBuilder>{
        LoginPage.routeName: (context) => LoginPage(),
      },
    );
  }
}
