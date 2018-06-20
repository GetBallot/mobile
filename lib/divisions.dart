import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'chopper/models/civic_info.dart';
import 'localizations.dart';
import 'user.dart';

class DivisionsPage extends StatelessWidget {
  final FirebaseUser firebaseUser;
  DivisionsPage(this.firebaseUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(BallotLocalizations.of(context).divisionsTitle),
        ),
        body: _createBody());
  }

  Widget _createBody() => StreamBuilder(
      stream: User
          .getRef(firebaseUser)
          .collection('triggers')
          .document('civicinfo')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.exists) {
          return _createDivisions(
              snapshot.data.data['representatives']['divisions']);
        }
        return Center(child: CircularProgressIndicator());
      });

  Widget _createDivisions(LinkedHashMap divisions) {
    final keys = divisions.keys.toList();
    keys.sort();
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final ocd = keys[index];
        final name = divisions[ocd]['name'];
        return ListTile(
          title: Text(name),
        );
      },
    );
  }
}
