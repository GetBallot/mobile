import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

import 'chopper/google_civic.dart';
import 'chopper/jaguar_serializer.dart';
import 'chopper/models/civic_info.dart';

import 'address_input.dart';
import 'localizations.dart';

class VotingProfile extends StatefulWidget {
  final String address;

  VotingProfile({Key key, this.address}) : super(key: key);

  @override
  _VotingProfileState createState() => _VotingProfileState(address);
}

class _VotingProfileState extends State<VotingProfile> {
  _VotingProfileState(this.address);
  String address;

  final GoogleCivic googleCivic = _createGoogleCivic();

  static GoogleCivic _createGoogleCivic() {
    final chopper = ChopperClient(
        baseUrl: "https://www.googleapis.com/civicinfo/v2",
        converter: const JaguarConverter(),
        apis: [GoogleCivicService()]);

    final service = chopper.service(GoogleCivicService);

    return GoogleCivic(service);
  }

  Future<Response> fetch(String address) async {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingProfileTitle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: fetch(address),
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

  Future _changeAddress() async {
    Map results = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddressInputPage(firstTime: false),
        ));

    if (results != null && results.containsKey("address")) {
      setState(() {
        address = results["address"];
      });
    }
  }

  ListTile _createVotingAddressListTile(Address address) {
    return ListTile(
        title: Text(BallotLocalizations.of(context).votingAddressLabel),
        subtitle: Text(address.toString()),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: _changeAddress,
        ));
  }

  Widget _createVoterInfoBody(VoterInfo data) {
    return ListView.builder(
      itemCount: data.contests.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _createVotingAddressListTile(data.normalizedInput);
        } else {
          final contest = data.contests[index];
          return ListTile(
            title: Text(contest.referendumTitle == null
                ? contest.office
                : contest.referendumTitle),
            subtitle: Text(contest.referendumSubtitle == null
                ? contest.district.name
                : contest.referendumSubtitle),
          );
        }
      },
    );
  }

  Widget _createRepresentativeInfoBody(RepresentativeInfo data) {
    final keys = data.divisions.keys.toList();
    return ListView.builder(
      itemCount: keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _createVotingAddressListTile(data.normalizedInput);
        } else {
          final ocd = keys[index - 1];
          final name = data.divisions[ocd].name;
          return ListTile(
            title: Text(name),
            subtitle: Text(ocd),
          );
        }
      },
    );
  }
}
