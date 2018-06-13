import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'localizations.dart';
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

  Widget _createBody() => StreamBuilder(
      stream: widget.ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          final contest =
              doc.exists ? doc.data['contests'][widget.contestIndex] : null;
          return _createContestBody(contest, !doc.exists);
        }
        return Center(child: CircularProgressIndicator());
      });

  Widget _createContestBody(contest, loading) {
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
              final candidate = candidates[index - 1];
              return ListTile(
                title: Text(
                  candidate['name'],
                ),
              );
            }
        }
      },
    );
  }
}
