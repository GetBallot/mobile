import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

    return StreamZip(inputStreams).map((results) {
      DocumentSnapshot electionSnapshot = results[0];

      DocumentSnapshot favsSnapshot = results[1];
      favs = favsSnapshot.exists ? favsSnapshot.data : {};

      if (electionSnapshot.exists) {
        final candidate = electionSnapshot.data['contests'][widget.contestIndex]
            ['candidates'][widget.candidateIndex];
        candidate['fav'] = Favorites.isFav(favs, candidate['favId']);
      }

      return electionSnapshot;
    });
  }

  List _mergeList(List oldList, List newList) {
    List results = [];
    results.addAll(oldList);
    newList.forEach((item) {
      if (!oldList.contains(item)) {
        results.add(item);
      }
    });
    return results;
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

    if (candidate['channels'] != null) {
      List channels = candidate['channels'];
      channels.forEach((channel) => rows.add(_createSocialChannel(channel)));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  Widget _createSocialChannel(Map channel) {
    var icon = Icon(Icons.link);
    var title = channel['type'];
    if (channel['id'] != null) {
      final uri = Uri.parse(channel['id']);
      final host = uri.host;
      if (host.endsWith("facebook.com")) {
        icon = Icon(FontAwesomeIcons.facebook);
        if (uri.pathSegments != null && uri.pathSegments.length == 1) {
          title = uri.pathSegments[0];
        }
      }
      if (host.endsWith("twitter.com")) {
        icon = Icon(FontAwesomeIcons.twitter);
        if (uri.pathSegments != null && uri.pathSegments.length == 1) {
          title = uri.pathSegments[0];
        }
      }
      if (host.endsWith("youtube.com")) {
        icon = Icon(FontAwesomeIcons.youtube);
      }
    }

    return ListTile(
      leading: icon,
      title: Text(title),
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
