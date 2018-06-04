import 'dart:async';
import 'dart:collection';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

import 'chopper/google_civic.dart';
import 'chopper/jaguar_serializer.dart';
import 'chopper/models/civic_info.dart';
import 'localizations.dart';

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

  Future<Response> fetch(GoogleCivic googleCivic, String address) async {
    try {
      return await googleCivic.voterinfo(address);
    } catch (e) {
      if (e is Response<String>) {
        if (e.statusCode == 400) {
          return await googleCivic.representatives(address);
        }
      }
      throw e;
    }
  }

  @override
  Widget build(context) {
    final service = chopper.service(GoogleCivicService) as GoogleCivicService;
    final googleCivic = GoogleCivic(service);

    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingProfileTitle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: fetch(googleCivic, widget.address),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data is Response<VoterInfo>) {
                    return _createVoterInfoBody(snapshot.data.body);
                  }
                  return _createRepresentativeInfoBody(snapshot.data.body);
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

  Widget _createVoterInfoBody(VoterInfo data) {
    return _createContests(data.contests);
  }

  Widget _createContests(List<Contest> contests) {
    return ListView.builder(
      itemCount: contests.length,
      itemBuilder: (context, index) {
        final contest = contests[index];
        return ListTile(
          title: Text(contest.referendumTitle == null
              ? contest.office
              : contest.referendumTitle),
          subtitle: Text(contest.referendumSubtitle == null
              ? contest.district.name
              : contest.referendumSubtitle),
        );
      },
    );
  }

  Widget _createRepresentativeInfoBody(RepresentativeInfo data) {
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
