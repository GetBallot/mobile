import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'address_input.dart';
import 'contest.dart';
import 'divisions.dart';
import 'localizations.dart';
import 'login.dart';
import 'polling_station.dart';
import 'user.dart';
import 'widgets.dart';

class VotingProfile extends StatefulWidget {
  VotingProfile({Key key, this.firebaseUser});

  final FirebaseUser firebaseUser;

  @override
  _VotingProfileState createState() =>
      _VotingProfileState(firebaseUser: firebaseUser);
}

class _VotingProfileState extends State<VotingProfile> {
  _VotingProfileState({Key key, this.firebaseUser});

  @override
  initState() {
    super.initState();
    _requestElectionUpdate();
  }

  FirebaseUser firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingProfileTitle),
        actions: <Widget>[
          firebaseUser.isAnonymous
              ? LoginPage.createLoginButton(
                  context,
                  _auth,
                  _googleSignIn,
                  (user) => setState(() {
                        firebaseUser = user.firebaseUser;
                      }))
              : LoginPage.createLogoutButton(context, _auth, _googleSignIn)
        ],
      ),
      body: _createBody(),
    );
  }

  _requestElectionUpdate() {
    User.getAddressRef(firebaseUser).get().then((snapshot) {
      if (snapshot.exists) {
        DateTime now = DateTime.now();
        DateTime lastUpdate = snapshot.data['updateUpcomingElection'];
        if (lastUpdate == null || now.difference(lastUpdate).inHours >= 12) {
          return snapshot.reference.updateData({'updateUpcomingElection': now});
        }
      }
    });
  }

  Widget _createAddressValue() => StreamBuilder(
      stream: User.getAddressRef(firebaseUser).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _createVotingAddressListTile(
              context, snapshot.data['address']);
        }
        // By default, show a loading spinner
        return Center(child: CircularProgressIndicator());
      });

  Widget _createBody() => StreamBuilder(
      stream: User.getUpcomingRef(firebaseUser).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _createVoteInfoBody(context, snapshot.data);
        }
        return Center(child: CircularProgressIndicator());
      });

  List _createListItems(context, DocumentSnapshot doc) {
    final items = [];

    items.add({'_listItemType': 'addressHeader'});
    items.add({'_listItemType': 'addressValue'});

    if (!(doc.exists)) {
      items.add({'_listItemType': 'loading'});
      return items;
    }

    final election =
        doc.exists && doc.data != null ? doc.data['election'] : null;

    if (election == null) {
      items.add({
        '_listItemType': 'h2',
        'text': BallotLocalizations.of(context).upcomingElectionHeader
      });
      items.add({
        '_listItemType': 'text',
        'text': BallotLocalizations.of(context).electionUnknown
      });
    }

    if (election != null && election['electionDay'] != null) {
      items.add({
        '_listItemType': 'h1',
        'text': election['name'] ??
            BallotLocalizations.of(context).upcomingElectionHeader
      });
      final electionDay = DateTime.parse(election['electionDay']);
      final formatter = DateFormat('yyyy-MM-dd');
      items.add(
          {'_listItemType': 'text', 'text': formatter.format(electionDay)});
    }

    List votingLocations =
        doc.exists && doc.data != null ? doc.data['votingLocations'] : null;

    if (votingLocations != null && votingLocations.length > 0) {
      items.add({'_listItemType': 'votingLocationHeader'});
      final location = votingLocations[0];
      location['_listItemType'] = 'votingLocation';
      items.add(location);
    }

    final List contests =
        doc.exists && doc.data != null ? doc.data['contests'] : null;

    if (contests != null) {
      items.add({
        '_listItemType': 'h2',
        'text': BallotLocalizations.of(context).contestsHeader
      });
      for (int i = 0; i < contests.length; ++i) {
        final contest = contests[i];
        contest['_listItemType'] = 'contest';
        contest['electionId'] = election['id'];
        contest['contestIndex'] = i;
        items.add(contest);
      }
    }

    return items;
  }

  Widget _createVoteInfoBody(context, DocumentSnapshot doc) {
    final theme = Theme.of(context);
    final items = _createListItems(context, doc);
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final Map item = items[index];
          final String type = item['_listItemType'];

          if (type == 'loading') {
            return ListTile(
                leading: CircularProgressIndicator(),
                title: Text(BallotLocalizations.of(context).loading));
          }

          if (type == 'addressHeader') {
            return getHeader(theme,
                title: BallotLocalizations.of(context).votingAddressLabel,
                trailing: BallotLocalizations.of(context).divisionsTitle,
                onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DivisionsPage(firebaseUser),
              ));
            });
          }

          if (type == 'addressValue') {
            return _createAddressValue();
          }

          if (type == 'votingLocationHeader') {
            List votingLocations = doc.exists && doc.data != null
                ? doc.data['votingLocations']
                : null;
            return getHeader(theme,
                title: BallotLocalizations.of(context).votingLocationTitle,
                trailing: BallotLocalizations.of(context).all, onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PollingStationsPage(votingLocations),
              ));
            });
          }

          if (type == 'votingLocation') {
            return PollingStationPage.getAddressHeader(context, item);
          }

          if (type == 'h1') {
            return getHeader(theme,
                title: item['text'],
                backgroundColor: theme.accentColor,
                textColor: theme.accentTextTheme.title.color);
          }

          if (type == 'h2') {
            return getHeader(theme, title: item['text']);
          }

          if (type == 'text') {
            return ListTile(title: Text(item['text']));
          }

          if (type == 'contest') {
            return ListTile(
                title: Text(item['name']),
                onTap: () {
                  final ref = User.getRef(firebaseUser)
                      .collection('elections')
                      .document('upcoming');
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ContestPage(
                        firebaseUser: firebaseUser,
                        ref: ref,
                        electionId: item['electionId'],
                        contestIndex: item['contestIndex']),
                  ));
                });
          }

          return Container();
        });
  }

  void _goToAddressInput(context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddressInputPage(
          firebaseUser: firebaseUser,
          firstTime: false,
          hint: BallotLocalizations.of(context).votingAddressLabel),
    ));
  }

  ListTile _createVotingAddressListTile(context, String address) {
    return ListTile(
        title: Text(address),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _goToAddressInput(context),
        ));
  }
}
