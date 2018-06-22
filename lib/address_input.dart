import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_autocomplete/flutter_google_places_autocomplete.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'credentials.dart';
import 'login.dart';
import 'user.dart';
import 'voting_profile.dart';

class AddressInputPage extends GooglePlacesAutocompleteWidget {
  final FirebaseUser firebaseUser;
  final bool firstTime;

  AddressInputPage({Key key, this.firebaseUser, this.firstTime, hint})
      : super(
          apiKey: GOOGLE_API_KEY,
          language: 'en',
          hint: hint,
          components: [new Component(Component.country, 'us')],
        );

  @override
  _AddressInputPageState createState() =>
      _AddressInputPageState(firebaseUser, firstTime);
}

class _AddressInputPageState extends GooglePlacesAutocompleteState {
  _AddressInputPageState(this.firebaseUser, this.firstTime);

  final FirebaseUser firebaseUser;
  final bool firstTime;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GoogleMapsPlaces _places = GoogleMapsPlaces(GOOGLE_API_KEY);
  final _searchScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _searchScaffoldKey,
      appBar: AppBar(
        title: AppBarPlacesAutoCompleteTextField(),
        actions: firstTime
            ? <Widget>[
                LoginPage.createLogoutButton(context, _auth, _googleSignIn),
              ]
            : null,
      ),
      body: GooglePlacesAutocompleteResult(onTap: (p) {
        _processPrediction(p, _searchScaffoldKey.currentState);
      }),
    );
  }

  Future<Null> _processPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      _updateUser(detail.result.formattedAddress);
    }
  }

  void _updateUser(address) async {
    User
        .getRef(firebaseUser)
        .collection('elections')
        .document('upcoming')
        .delete();

    User
        .getRef(firebaseUser)
        .collection('triggers')
        .document('address')
        .setData({'address': address});

    if (firstTime) {
      var route = MaterialPageRoute(
        builder: (context) => VotingProfile(firebaseUser: firebaseUser),
      );
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).pop();
    }
  }
}
