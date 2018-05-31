import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localizations.dart';
import 'address_input.dart';

void main() => runApp(Ballot());

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Add login
    return AddressInputPage();
  }
}

class Ballot extends StatelessWidget {
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
      home: MainPage(),
    );
  }
}
