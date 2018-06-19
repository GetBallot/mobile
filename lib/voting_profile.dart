import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'address_input.dart';
import 'chopper/google_civic.dart';
import 'chopper/jaguar_serializer.dart';
import 'chopper/models/civic_info.dart';
import 'contest.dart';
import 'localizations.dart';
import 'login.dart';
import 'user.dart';
import 'widgets.dart';

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
      final response = await _fetchVoterInfo(address);
      _fetchRepresentativeInfo(address, false);
      return response;
    } catch (e) {
      if (e is Response<String>) {
        if (e.statusCode == 400) {
          _deleteVoterInfo();
          return _fetchRepresentativeInfo(address, true);
        }
      }
      throw e;
    }
  }

  Future<Response> _fetchVoterInfo(String address) async {
    final Response<VoterInfo> response = await _googleCivic.voterinfo(address);
    _saveVoterInfo(response.body);
    return response;
  }

  Future<Response> _fetchRepresentativeInfo(
      String address, bool updateUpcomingElection) async {
    final Response<RepresentativeInfo> response =
        await _googleCivic.representatives(address);
    _saveRepresentativeInfo(response.body, updateUpcomingElection);
    return response;
  }

  Stream<Response> _getUserStream() => User
      .getAddressRef(firebaseUser)
      .snapshots()
      .map((snapshot) => snapshot["address"])
      .asyncMap((snapshot) => _fetch(snapshot));

  Stream<DocumentSnapshot> _getElectionStream() => User
      .getRef(firebaseUser)
      .collection("elections")
      .document("upcoming")
      .snapshots();

  void _saveVoterInfo(VoterInfo voterInfo) async {
    User
        .getRef(widget.firebaseUser)
        .collection("triggers")
        .document("voterinfo")
        .setData({"lang": _getLang(), "voterinfo": voterInfo.serialize()});
  }

  void _deleteVoterInfo() async {
    User
        .getRef(widget.firebaseUser)
        .collection("triggers")
        .document("voterinfo")
        .delete();
  }

  void _saveRepresentativeInfo(
      RepresentativeInfo repInfo, bool updateUpcomingElection) async {
    final data = {'lang': _getLang(), 'representatives': repInfo.serialize()};
    if (updateUpcomingElection) {
      data['updateUpcomingElection'] = DateTime.now();
    }

    User
        .getRef(widget.firebaseUser)
        .collection("triggers")
        .document("representatives")
        .setData(data);
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
      body: _createBody(),
    );
  }

  Widget _createAddressHeader() => StreamBuilder(
      stream: _getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Response<VoterInfo>) {
            VoterInfo voterInfo = snapshot.data.body;
            return _createVotingAddressListTile(voterInfo.normalizedInput);
          }
          RepresentativeInfo repInfo = snapshot.data.body;
          return _createVotingAddressListTile(repInfo.normalizedInput);
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      _googleCivic.getErrorMessage(context, snapshot.error),
                      style: TextStyle(fontSize: 20.0)),
                ),
                RaisedButton(
                  child: Text(BallotLocalizations.of(context).changeAddress),
                  onPressed: _goToAddressInput,
                )
              ],
            )),
          );
        }

        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      });

  Widget _createBody() => StreamBuilder(
      stream: _getElectionStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          final election =
              doc.exists && doc.data != null ? doc.data['election'] : null;
          final contests =
              doc.exists && doc.data != null ? doc.data['contests'] : null;
          return _createVoteInfoBody(election, contests, !doc.exists);
        }
        return Center(child: CircularProgressIndicator());
      });

  Widget _createVoteInfoBody(election, contests, loading) {
    var headerCount = 2; // address header
    if (loading) {
      headerCount += 1; // loading indicator
    }

    final contestsCount = _getContestsCount(contests);
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: headerCount + contestsCount,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return getHeader(
                theme, BallotLocalizations.of(context).votingAddressLabel);
          case 1:
            return _createAddressHeader();
          case 2:
            if (loading) {
              return ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text(BallotLocalizations.of(context).loading));
            }
            return _getContestItem(
                context, election, contests, index - headerCount);
          default:
            return _getContestItem(
                context, election, contests, index - headerCount);
        }
      },
    );
  }

  int _getContestsCount(contests) =>
      (contests == null) ? 0 : contests.length + 1;
  Widget _getContestItem(context, election, contests, index) {
    final theme = Theme.of(context);
    if (index == 0) {
      return getHeader(theme, BallotLocalizations.of(context).contestsHeader);
    }

    if (contests == null) {
      return ListTile(
          title: Text(BallotLocalizations.of(context).nullContests));
    }

    final contestIndex = index - 1;
    final contest = contests[contestIndex];
    return ListTile(
        title: Text(contest['name']),
        onTap: () {
          final ref = User
              .getRef(firebaseUser)
              .collection('elections')
              .document('upcoming');
          Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContestPage(
                    firebaseUser: widget.firebaseUser,
                    ref: ref,
                    electionId: election['id'],
                    contestIndex: contestIndex),
              ));
        });
  }

  void _goToAddressInput() {
    Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddressInputPage(
              firebaseUser: widget.firebaseUser, firstTime: false),
        ));
  }

  ListTile _createVotingAddressListTile(Address address) {
    return ListTile(
        title: Text(address.toString()),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: _goToAddressInput,
        ));
  }
}
