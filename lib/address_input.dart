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
    User
        .getRef(widget.firebaseUser)
        .collection("elections")
        .document("upcoming")
        .delete();

    User
        .getRef(widget.firebaseUser)
        .collection("triggers")
        .document("address")
        .setData({"address": _address});

    if (widget.firstTime) {
      var route = MaterialPageRoute(
        builder: (context) => VotingProfile(firebaseUser: widget.firebaseUser),
      );
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).addressInputTitle),
        actions: widget.firstTime
            ? <Widget>[
                LoginPage.createLogoutButton(context, _auth, _googleSignIn),
              ]
            : null,
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
                      "Castle Rock",
                      "488 Black Feather Loop, Castle Rock, CO",
                      theme,
                      addressController),
                  _createAddressExampleButton(
                      "Firestone",
                      "326 Jackson Ave, Firestone, CO 80520",
                      theme,
                      addressController),
                  _createAddressExampleButton(
                      "Virginia",
                      "1716 Winder St, Richmond, VA 23220",
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
