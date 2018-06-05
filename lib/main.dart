import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'localizations.dart';
import 'address_input.dart';
import 'login.dart';

void main() => runApp(Ballot());

class Ballot extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async => await _auth.currentUser();

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
      home: FutureBuilder<FirebaseUser>(
        future: getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.data == null) {
            return LoginPage();
          } else {
            return AddressInputPage();
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
