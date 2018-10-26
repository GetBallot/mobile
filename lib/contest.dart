import 'package:async/async.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'candidate.dart';
import 'favorites.dart';
import 'localizations.dart';
import 'user.dart';
import 'widgets.dart';

class ContestPage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final String electionId;
  final DocumentReference ref;
  final int contestIndex;

  ContestPage(
      {Key key,
      this.firebaseUser,
      this.electionId,
      this.ref,
      this.contestIndex})
      : super(key: key);

  @override
  _ContestPageState createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  _ContestPageState();

  Map<String, dynamic> favs = {};

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
    final inputStreams = [widget.ref.snapshots(), favsStream];

    return StreamZip(inputStreams).map((results) {
      DocumentSnapshot electionSnapshot = results[0];

      DocumentSnapshot favsSnapshot = results[1];
      favs = favsSnapshot.exists ? favsSnapshot.data : {};

      if (electionSnapshot.exists) {
        final contest = electionSnapshot.data['contests'][widget.contestIndex];
        if (contest != null) {
          final candidates = contest['candidates'];
          if (candidates != null) {
            candidates.forEach((candidate) {
              candidate['fav'] = Favorites.isFav(favs, candidate['favId']) ||
                  (candidate['oldFavId'] != null &&
                      Favorites.isFav(favs, candidate['oldFavId']));
            });
          }
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
    bool isReferendum = contest != null && contest['referendumTitle'] != null;
    final candidates = contest == null ? [] : contest['candidates'];
    int referendumCount = 0;
    if (isReferendum) {
      if (contest['referendumText'] != null) {
        referendumCount += 1;
      }
    }
    int count = 1 + candidates.length + (isReferendum ? referendumCount : 0);
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        switch (index) {
          case 0:
            return getHeader(theme,
                title: contest['name'],
                subtitle: contest['referendumSubtitle']);
          default:
            if (loading) {
              return ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text(BallotLocalizations.of(context).loading));
            }
            if (referendumCount > 0) {
              if (index == 1) {
                return ListTile(title: Text(contest['referendumText']));
              }
            }
            if (candidates == null) {
              return ListTile(
                  title: Text(BallotLocalizations.of(context).nullCandidates));
            } else {
              final candidateIndex = index - 1 - referendumCount;
              final candidate = candidates[candidateIndex];
              return GestureDetector(
                child: ListTile(
                  title: Text(
                    candidate['name'],
                  ),
                  subtitle: candidate['party'] != null
                      ? Text(candidate['party'],
                          style: TextStyle(fontSize: 14.0))
                      : null,
                  trailing: GestureDetector(
                      child: Icon(
                          candidate['fav'] ? Icons.star : Icons.star_border,
                          color: theme.accentColor),
                      onTap: () {
                        setState(() {
                          Favorites.setCandidateFavorite(
                              favs, widget.firebaseUser, candidate);
                        });
                      }),
                ),
                onTap: isReferendum
                    ? null
                    : () {
                        final ref = User.getRef(widget.firebaseUser)
                            .collection('elections')
                            .document('upcoming');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CandidatePage(
                                firebaseUser: widget.firebaseUser,
                                ref: ref,
                                electionId: widget.electionId,
                                contestIndex: widget.contestIndex,
                                candidateIndex: candidateIndex,
                              ),
                        ));
                      },
              );
            }
        }
      },
    );
  }
}
