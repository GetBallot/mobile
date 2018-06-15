import 'package:async/async.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'localizations.dart';
import 'user.dart';
import 'widgets.dart';

class ContestPage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final DocumentReference ref;
  final int contestIndex;

  ContestPage({Key key, this.firebaseUser, this.ref, this.contestIndex})
      : super(key: key);

  @override
  _ContestPageState createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  _ContestPageState();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).contestTitle),
      ),
      body: _createBody(),
    );
  }

  Stream _createStream() {
    Stream<DocumentSnapshot> favsStream =
        User.getFavCandidatesRef(widget.firebaseUser).snapshots();
    return StreamZip([widget.ref.snapshots(), favsStream]).map((results) {
      DocumentSnapshot electionSnapshot = results[0];

      DocumentSnapshot favsSnapshot = results[1];

      if (electionSnapshot.exists) {
        final contest = electionSnapshot.data['contests'][widget.contestIndex];
        if (contest != null) {
          final map = favsSnapshot.exists ? favsSnapshot.data : null;
          final candidates = contest['candidates'];
          candidates.forEach((candidate) {
            final favData = map == null ? null : map[candidate['favId']];
            candidate['fav'] = map == null
                ? false
                : favData == null ? false : favData['fav'] ?? false;
          });
        }
      }

      return electionSnapshot;
    });
  }

  Widget _createBody() => StreamBuilder(
      stream: _createStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          final election = doc.exists ? doc.data : null;
          final contest =
              doc.exists ? doc.data['contests'][widget.contestIndex] : null;
          return _createContestBody(election, contest, !doc.exists);
        }
        return Center(child: CircularProgressIndicator());
      });

  Widget _createContestBody(election, contest, loading) {
    final candidates = contest == null ? null : contest['candidates'];
    return ListView.builder(
      itemCount: (candidates == null ? 1 : candidates.length) + 1,
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        switch (index) {
          case 0:
            return getHeader(theme, contest['name']);
          default:
            if (loading) {
              return new ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text(BallotLocalizations.of(context).loading));
            }
            if (candidates == null) {
              return ListTile(
                  title: Text(BallotLocalizations.of(context).nullCandidates));
            } else {
              final candidateIndex = index - 1;
              final candidate = candidates[candidateIndex];
              return ListTile(
                title: Text(
                  candidate['name'],
                ),
                trailing: new GestureDetector(
                    child: Icon(
                        candidate['fav'] ? Icons.star : Icons.star_border,
                        color: theme.accentColor),
                    onTap: () {
                      setState(() {
                        _setCandidateFavorite(
                            candidate['favId'], candidate['fav']);
                      });
                    }),
              );
            }
        }
      },
    );
  }

  void _setCandidateFavorite(String favId, bool oldValue) {
    final data = {'fav': !oldValue};
    User
        .getFavCandidatesRef(widget.firebaseUser)
        .setData({favId: data}, merge: true);
  }
}
