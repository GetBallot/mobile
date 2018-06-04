import 'dart:async';
import 'dart:convert';
import 'package:Ballot/localizations.dart';
import 'package:chopper/chopper.dart';

import 'package:Ballot/credentials.dart';
import 'models/representative_info.dart';

part 'google_civic.chopper.dart';

@ChopperApi("GoogleCivicService")
abstract class GoogleCivicDefinition {
  @Get(url: "/representatives")
  Future<Response<RepresentativeInfo>> representatives(@Query() String address,
      @Query() bool includeOffices, @Query() String key);
}

class GoogleCivic {
  final GoogleCivicService service;

  GoogleCivic(this.service);

  Future<Response<RepresentativeInfo>> representatives(String address) {
    return service.representatives(address, false, GOOGLE_API_KEY);
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
