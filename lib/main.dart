import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'address_input.dart';
import 'localizations.dart';
import 'login.dart';
import 'user.dart';
import 'voting_profile.dart';

void main() => runApp(Ballot());

class Ballot extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    if (firebaseUser == null) {
      return null;
    }

    DocumentSnapshot snapshot = await User.getReference(firebaseUser).get();

    return User(firebaseUser, snapshot.data);
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
            if (user.data != null && user.data["address"] != null) {
              return VotingProfile(user: user);
            } else {
              return AddressInputPage(user: user);
            }
          }
        },
      ),
      routes: <String, WidgetBuilder>{
        LoginPage.routeName: (context) => LoginPage(),
        AddressInputPage.routeName: (context) => AddressInputPage(),
      },
    );
  }
}
