import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'address_input.dart';
import 'chopper/google_civic.dart';
import 'chopper/jaguar_serializer.dart';
import 'chopper/models/civic_info.dart';
import 'localizations.dart';
import 'login.dart';
import 'user.dart';

class VotingProfile extends StatefulWidget {
  final FirebaseUser firebaseUser;

  VotingProfile({Key key, this.firebaseUser}) : super(key: key);

  @override
  _VotingProfileState createState() => _VotingProfileState(firebaseUser);
}

class _VotingProfileState extends State<VotingProfile> {
  _VotingProfileState(this.firebaseUser);
  FirebaseUser firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final GoogleCivic _googleCivic = _createGoogleCivic();

  static GoogleCivic _createGoogleCivic() {
    final chopper = ChopperClient(
        baseUrl: "https://www.googleapis.com/civicinfo/v2",
        converter: const JaguarConverter(),
        apis: [GoogleCivicService()]);

    final service = chopper.service(GoogleCivicService);

    return GoogleCivic(service);
  }

  Future<Response> _fetch(String address) async {
    try {
      return await _googleCivic.voterinfo(address);
    } catch (e) {
      if (e is Response<String>) {
        if (e.statusCode == 400) {
          return await _googleCivic.representatives(address);
        }
      }
      throw e;
    }
  }

  Stream<Response> _getUserStream() => User
      .getReference(firebaseUser)
      .collection("triggers")
      .document("address")
      .snapshots()
      .map((snapshot) => snapshot["address"])
      .asyncMap((snapshot) => _fetch(snapshot));

  void _saveVoterInfo(VoterInfo voterInfo) async {
    User
        .getReference(widget.firebaseUser)
        .collection("triggers")
        .document("voterinfo")
        .setData({"lang": _getLang(), "voterinfo": voterInfo.serialize()});
  }

  void _saveRepresentativeInfo(RepresentativeInfo repInfo) async {
    User
        .getReference(widget.firebaseUser)
        .collection("triggers")
        .document("representatives")
        .setData({"lang": _getLang(), "representatives": repInfo.serialize()});
  }

  // TODO: Use BallotLocalizations to always get a supported language
  String _getLang() {
    final lang = Intl.defaultLocale;
    return ['en'].contains(lang) ? lang : 'en';
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(BallotLocalizations.of(context).votingProfileTitle),
          actions: <Widget>[
            LoginPage.createLogoutButton(context, _auth, _googleSignIn),
          ],
        ),
        body: StreamBuilder(
            stream: _getUserStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data is Response<VoterInfo>) {
                  VoterInfo voterInfo = snapshot.data.body;
                  _saveVoterInfo(voterInfo);
                  return _createVoterInfoBody(voterInfo);
                }
                RepresentativeInfo repInfo = snapshot.data.body;
                _saveRepresentativeInfo(repInfo);
                return _createRepresentativeInfoBody(repInfo);
              } else if (snapshot.hasError) {
                return new Center(
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            _googleCivic.getErrorMessage(
                                context, snapshot.error),
                            style: TextStyle(fontSize: 20.0)),
                      ),
                      RaisedButton(
                        child:
                            Text(BallotLocalizations.of(context).changeAddress),
                        onPressed: _goToAddressInput,
                      )
                    ],
                  )),
                );
              }

              // By default, show a loading spinner
              return new Center(child: CircularProgressIndicator());
            }));
  }

  void _goToAddressInput() {
    Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddressInputPage(
              firebaseUser: widget.firebaseUser, firstTime: false),
        ));
  }

  ListTile _createVotingAddressListTile(Address address) {
    return ListTile(
        title: Text(BallotLocalizations.of(context).votingAddressLabel),
        subtitle: Text(address.toString()),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: _goToAddressInput,
        ));
  }

  Widget _createVoterInfoBody(VoterInfo data) {
    return ListView.builder(
      itemCount: data.contests.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _createVotingAddressListTile(data.normalizedInput);
        } else {
          final contest = data.contests[index - 1];
          return ListTile(
            title: Text(contest.referendumTitle == null
                ? contest.office
                : contest.referendumTitle),
            subtitle: Text(contest.referendumSubtitle == null
                ? contest.district.name
                : contest.referendumSubtitle),
          );
        }
      },
    );
  }

  Widget _createRepresentativeInfoBody(RepresentativeInfo data) {
    final keys = data.divisions.keys.toList();
    return ListView.builder(
      itemCount: keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _createVotingAddressListTile(data.normalizedInput);
        } else {
          final ocd = keys[index - 1];
          final name = data.divisions[ocd].name;
          return ListTile(
            title: Text(name),
            subtitle: Text(ocd),
          );
        }
      },
    );
  }
}
