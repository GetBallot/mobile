import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'address_input.dart';
import 'contest.dart';
import 'divisions.dart';
import 'localizations.dart';
import 'login.dart';
import 'polling_station.dart';
import 'user.dart';
import 'widgets.dart';

class VotingProfile extends StatelessWidget {
  VotingProfile({Key key, this.firebaseUser}) : super(key: key);

  final FirebaseUser firebaseUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Widget _createVoteInfoBody(context, DocumentSnapshot doc) {
    final election =
        doc.exists && doc.data != null ? doc.data['election'] : null;
    final contests =
        doc.exists && doc.data != null ? doc.data['contests'] : null;
    final votingLocations =
        doc.exists && doc.data != null ? doc.data['votingLocations'] : null;
    final loading = !doc.exists;

    var headerCount = 2; // address header
    if (loading) {
      headerCount += 1; // loading indicator
    }

    final votingLocationsCount = _getVotingLocationsCount(votingLocations);
    final contestsCount = _getContestsCount(contests);
    final theme = Theme.of(context);
    return ListView.builder(
      itemCount: headerCount + votingLocationsCount + contestsCount,
      itemBuilder: (context, index) {
        if (index == 0) {
          return getHeader(theme,
              text: BallotLocalizations.of(context).votingAddressLabel,
              trailing: BallotLocalizations.of(context).divisionsTitle,
              onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DivisionsPage(firebaseUser),
                ));
          });
        }
        if (index == 1) {
          return _createAddressHeader();
        }
        if (index == 2) {
          if (loading) {
            return ListTile(
                leading: CircularProgressIndicator(),
                title: Text(BallotLocalizations.of(context).loading));
          }
          if (votingLocationsCount > 0) {
            return _getPollingStationItem(
                context,
                BallotLocalizations.of(context).votingLocationTitle,
                votingLocations,
                index - headerCount);
          } else {
            return _getContestItem(context, election, contests,
                index - headerCount - votingLocationsCount);
          }
        }
        if (index - headerCount < votingLocationsCount) {
          return _getPollingStationItem(
              context,
              BallotLocalizations.of(context).votingLocationTitle,
              votingLocations,
              index - headerCount);
        } else {
          return _getContestItem(context, election, contests,
              index - headerCount - votingLocationsCount);
        }
      },
    );
  }

  int _getVotingLocationsCount(items) =>
      (items == null || items.length == 0) ? 0 : 2;
  Widget _getPollingStationItem(context, header, stations, index) {
    final theme = Theme.of(context);
    if (index == 0) {
      return getHeader(theme,
          text: header,
          trailing: BallotLocalizations.of(context).all, onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PollingStationsPage(stations),
            ));
      });
    }
    final stationIndex = index - 1;
    final station = stations[stationIndex];

    return PollingStationPage.getAddressHeader(context, station);
  }

  int _getContestsCount(contests) =>
      (contests == null) ? 0 : contests.length + 1;
  Widget _getContestItem(context, election, contests, index) {
    final theme = Theme.of(context);
    if (index == 0) {
      return getHeader(theme,
          text: BallotLocalizations.of(context).contestsHeader);
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
                    firebaseUser: firebaseUser,
                    ref: ref,
                    electionId: election['id'],
                    contestIndex: contestIndex),
              ));
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
