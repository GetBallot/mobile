// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_civic.dart';

// **************************************************************************
// Generator: ChopperGenerator
// **************************************************************************

class GoogleCivicService extends ChopperService
    implements GoogleCivicDefinition {
  Future<Response<RepresentativeInfo>> representatives(
      String address, bool includeOffices, String key) {
    final url = '/representatives';
    final params = {
      'address': address,
      'includeOffices': includeOffices,
      'key': key
    };
    final request = new Request('GET', url, parameters: params);
    return client.send<RepresentativeInfo>(request,
        responseType: RepresentativeInfo);
  }

  Future<Response<VoterInfo>> voterinfo(String address, String key) {
    final url = '/voterinfo';
    final params = {'address': address, 'key': key};
    final request = new Request('GET', url, parameters: params);
    return client.send<VoterInfo>(request, responseType: VoterInfo);
  }
}
