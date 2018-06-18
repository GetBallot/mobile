import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'favorites.dart';
import 'localizations.dart';
import 'user.dart';

class CandidatePage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final String electionId;
  final DocumentReference ref;
  final int contestIndex;
  final int candidateIndex;

  CandidatePage(
      {Key key,
      this.firebaseUser,
      this.electionId,
      this.ref,
      this.contestIndex,
      this.candidateIndex})
      : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  Map<String, dynamic> favs = {};

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).candidateTitle),
      ),
      body: _createBody(),
    );
  }

  Stream _createStream() {
    Stream<DocumentSnapshot> favsStream =
        User.getFavCandidatesRef(widget.firebaseUser).snapshots();
    final inputStreams = [widget.ref.snapshots(), favsStream];

    if (widget.electionId != null) {
      inputStreams.add(Firestore.instance
          .collection('elections')
          .document(widget.electionId)
          .snapshots());
    }

    return StreamZip(inputStreams).map((results) {
      DocumentSnapshot electionSnapshot = results[0];

      DocumentSnapshot favsSnapshot = results[1];
      favs = favsSnapshot.exists ? favsSnapshot.data : {};

      DocumentSnapshot supplementSnapshot =
          results.length >= 3 ? results[2] : null;
      final supplement =
          (supplementSnapshot != null && supplementSnapshot.exists)
              ? supplementSnapshot.data
              : null;
      Map favIdMap = supplement == null ? {} : supplement['favIdMap'] ?? {};

      if (electionSnapshot.exists) {
        final candidate = electionSnapshot.data['contests'][widget.contestIndex]
            ['candidates'][widget.candidateIndex];
        Favorites.updateCandidate(favs, favIdMap, candidate);
      }

      return electionSnapshot;
    });
  }

  Widget _createBody() => StreamBuilder(
      stream: _createStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot doc = snapshot.data;
          if (!doc.exists) {
            return Center(child: Text(BallotLocalizations.of(context).error));
          }
          final candidate = doc.data['contests'][widget.contestIndex]
              ['candidates'][widget.candidateIndex];
          return _createCandidateBody(candidate);
        }
        return Center(child: CircularProgressIndicator());
      });

  Widget _createCandidateBody(Map candidate) {
    final theme = Theme.of(context);
    final List<Widget> rows = [
      ListTile(
        leading: candidate['photoUrl'] != null
            ? Image.network(candidate['photoUrl'])
            : null,
        title: Text(candidate['name'], style: TextStyle(fontSize: 20.0)),
        subtitle: candidate['party'] != null
            ? Text(candidate['party'], style: TextStyle(fontSize: 14.0))
            : null,
        trailing: GestureDetector(
            child: Icon(candidate['fav'] ? Icons.star : Icons.star_border,
                color: theme.accentColor, size: 36.0),
            onTap: () {
              setState(() {
                Favorites.setCandidateFavorite(
                    favs, widget.firebaseUser, candidate);
              });
            }),
      )
    ];

    final phone = candidate['phone'];
    if (phone != null) {
      rows.add(
        ListTile(
          leading: Icon(Icons.phone),
          title: Text(phone),
          onTap: () {
            _launchUrl('tel://' + phone);
          },
        ),
      );
    }

    final email = candidate['email'];
    if (email != null) {
      rows.add(
        ListTile(
          leading: Icon(Icons.email),
          title: Text(email),
          onTap: () {
            _launchUrl('mailto:' + email);
          },
        ),
      );
    }

    final candidateUrl = candidate['candidateUrl'];
    if (candidateUrl != null) {
      rows.add(
        ListTile(
          leading: Icon(Icons.language),
          title: Text(candidateUrl),
          onTap: () {
            _launchUrl(candidateUrl);
          },
        ),
      );
    }

    if (candidate.containsKey('channels')) {
      List channels = candidate['channels'];
      channels.forEach((channel) => rows.add(_createSocialChannel(channel)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _createSocialChannel(Map channel) {
    return ListTile(
      title: Text(channel['type']),
      onTap: () {
        _launchUrl(channel['id']);
      },
    );
  }

  void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
