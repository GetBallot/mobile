import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'localizations.dart';
import 'login.dart';
import 'user.dart';
import 'voting_profile.dart';

class AddressInputPage extends StatefulWidget {
  static const String routeName = "/address_input";

  final FirebaseUser firebaseUser;
  bool firstTime;

  AddressInputPage({Key key, this.firebaseUser, this.firstTime})
      : super(key: key);

  @override
  _AddressInputPageState createState() => _AddressInputPageState();
}

class _AddressInputPageState extends State<AddressInputPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _formKey = GlobalKey<FormState>();
  String _address;

  void _updateUser() async {
    DocumentReference ref = User.getReference(widget.firebaseUser);

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(ref);
      final hadAddress = snapshot.exists && snapshot["address"] != null;

      if (snapshot.exists) {
        await tx.update(snapshot.reference, {"address": _address});
      } else {
        await tx.set(snapshot.reference, {"address": _address});
      }

      if (hadAddress) {
        Navigator.of(context).pop({"address": _address});
      } else {
        var route = MaterialPageRoute(
          builder: (context) =>
              VotingProfile(firebaseUser: widget.firebaseUser),
        );
        Navigator.of(context).pushReplacement(route);
      }
    });
  }

  Future<FirebaseUser> _signOut() async {
    await _auth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).addressInputTitle),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut().then((_) => Navigator
                  .of(context)
                  .pushReplacementNamed(LoginPage.routeName));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: addressController,
                  onSaved: (val) => _address = val,
                  decoration: InputDecoration(
                      labelText:
                          BallotLocalizations.of(context).votingAddressLabel),
                  validator: (val) {
                    return val.isEmpty
                        ? BallotLocalizations.of(context).required
                        : null;
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Text('Examples:'),
                  _createAddressExampleButton(
                      BallotLocalizations.of(context).california,
                      '1456 Edgewood Dr, Palo Alto, CA 94301',
                      theme,
                      addressController),
                  _createAddressExampleButton(
                      BallotLocalizations.of(context).colorado,
                      '5101 E Montview Blvd, Denver, CO 80207',
                      theme,
                      addressController),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text(BallotLocalizations.of(context).lookup),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _updateUser();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createAddressExampleButton(text, address, theme, addressController) {
    return FlatButton(
      child: Text(text,
          style: TextStyle(
              color: theme.accentColor, decoration: TextDecoration.underline)),
      onPressed: () {
        addressController.text = address;
      },
    );
  }
}
