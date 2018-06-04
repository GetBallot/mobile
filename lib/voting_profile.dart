import 'dart:collection';

import 'package:flutter/material.dart';

import 'localizations.dart';

import 'package:chopper/chopper.dart';
import 'chopper/google_civic.dart';
import 'chopper/jaguar_serializer.dart';
import 'chopper/models/representative_info.dart';

class VotingProfile extends StatefulWidget {
  final String address;

  VotingProfile({Key key, this.address}) : super(key: key);

  @override
  _VotingProfileState createState() => _VotingProfileState();
}

class _VotingProfileState extends State<VotingProfile> {
  final chopper = new ChopperClient(
      baseUrl: "https://www.googleapis.com/civicinfo/v2",
      converter: const JaguarConverter(),
      apis: [new GoogleCivicService()]);

  @override
  Widget build(BuildContext context) {
    final service = chopper.service(GoogleCivicService) as GoogleCivicService;
    final googleCivic = GoogleCivic(service);

    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingProfileTitle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: googleCivic.representatives(widget.address),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _createBody(snapshot.data.body);
                } else if (snapshot.hasError) {
                  return new Center(
                      child: Text(googleCivic.getErrorMessage(
                          context, snapshot.error)));
                }

                // By default, show a loading spinner
                return new Center(child: CircularProgressIndicator());
              })),
    );
  }

  Widget _createBody(RepresentativeInfo data) {
    return _createDivisions(data.divisions);
  }

  Widget _createDivisions(LinkedHashMap<String, Division> divisions) {
    final keys = divisions.keys.toList();
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final ocd = keys[index];
        final name = divisions[ocd].name;
        return ListTile(
          title: Text(name),
          subtitle: Text(ocd),
        );
      },
    );
  }
}
