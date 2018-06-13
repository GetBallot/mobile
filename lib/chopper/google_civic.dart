import 'dart:async';
import 'dart:convert';
import 'package:Ballot/localizations.dart';
import 'package:chopper/chopper.dart';

import 'package:Ballot/credentials.dart';
import 'models/civic_info.dart';

part 'google_civic.chopper.dart';

@ChopperApi("GoogleCivicService")
abstract class GoogleCivicDefinition {
  @Get(url: "/representatives")
  Future<Response<RepresentativeInfo>> representatives(@Query() String address,
      @Query() bool includeOffices, @Query() String key);

  @Get(url: "/voterinfo")
  Future<Response<VoterInfo>> voterinfo(
      @Query() String address, @Query() int electionId, @Query() String key);
}

class GoogleCivic {
  static const SAMPLE_VOTER_INFO_ADDRESS =
      "1263 Pacific Avenue, Kansas City, KS 66102";

  final GoogleCivicService service;

  GoogleCivic(this.service);

  Future<Response<RepresentativeInfo>> representatives(String address) {
    return service.representatives(address, true, GOOGLE_API_KEY);
  }

  Future<Response<VoterInfo>> voterinfo(String address) {
    int electionId = (address == SAMPLE_VOTER_INFO_ADDRESS) ? 2000 : null;
    return service.voterinfo(address, electionId, GOOGLE_API_KEY);
  }

  String getErrorMessage(context, Response<String> response) {
    Map<String, dynamic> responseJson = json.decode(response.body);
    if (responseJson["error"] != null &&
        responseJson["error"]["message"] != null) {
      return responseJson["error"]["message"];
    }
    return BallotLocalizations.of(context).error;
  }
}
