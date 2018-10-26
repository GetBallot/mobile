import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'credentials.dart';
import 'login.dart';
import 'user.dart';
import 'voting_profile.dart';

class AddressInputPage extends PlacesAutocompleteWidget {
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

class _AddressInputPageState extends PlacesAutocompleteState {
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
        actions: firstTime && !firebaseUser.isAnonymous
            ? <Widget>[
                LoginPage.createLogoutButton(context, _auth, _googleSignIn),
              ]
            : null,
      ),
      body: PlacesAutocompleteResult(onTap: (p) {
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
    final oldSnap = await User.getAddressRef(firebaseUser).get();

    if (oldSnap.exists) {
      Map data = oldSnap.data;
      if (data['address'] != address) {
        User.getUpcomingRef(firebaseUser).delete();
        User.getRef(firebaseUser)
            .collection('triggers')
            .document('civicinfo')
            .delete();
        User.getRef(firebaseUser)
            .collection('elections')
            .document('upcoming')
            .delete();
      }
    }

    User.getAddressRef(firebaseUser)
        .setData({'address': address, 'lang': Intl.defaultLocale});

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
