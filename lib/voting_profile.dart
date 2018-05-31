import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'localizations.dart';
import 'representative_info.dart';
import 'credentials.dart';

Future<RepresentativeInfo> fetchRepresentativeInfo(context, address) async {
  final response = await http.get(
      "https://www.googleapis.com/civicinfo/v2/representatives?key=$GOOGLE_API_KEY&address=${Uri.encodeQueryComponent(address)}&includeOffices=false");
  final responseJson = json.decode(response.body);

  if (response.statusCode != 200) {
    String message = BallotLocalizations.of(context).error;
    if (responseJson["error"] != null &&
        responseJson["error"]["message"] != null) {
      message = responseJson["error"]["message"];
    }
    throw message;
  }

  return RepresentativeInfo.fromJson(responseJson);
}

class VotingProfile extends StatefulWidget {
  final String address;

  VotingProfile({Key key, this.address}) : super(key: key);

  @override
  _VotingProfileState createState() => _VotingProfileState();
}

class _VotingProfileState extends State<VotingProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingProfileTitle),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: fetchRepresentativeInfo(context, widget.address),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _createBody(snapshot.data);
                } else if (snapshot.hasError) {
                  return new Center(child: Text(snapshot.error));
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
