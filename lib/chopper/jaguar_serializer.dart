import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import "models/civic_info.dart";

part "jaguar_serializer.g.dart";

@GenSerializer()
class DivisionSerializer extends Serializer<Division>
    with _$DivisionSerializer {}

@GenSerializer()
class AddressSerializer extends Serializer<Address> with _$AddressSerializer {}

@GenSerializer(serializers: [AddressSerializer, DivisionSerializer])
class RepresentativeInfoSerializer extends Serializer<RepresentativeInfo>
    with _$RepresentativeInfoSerializer {}

@GenSerializer()
class SourceSerializer extends Serializer<Source> with _$SourceSerializer {}

@GenSerializer(serializers: [AddressSerializer, SourceSerializer])
class PollingLocationSerializer extends Serializer<PollingLocation>
    with _$PollingLocationSerializer {}

@GenSerializer()
class DistrictSerializer extends Serializer<District>
    with _$DistrictSerializer {}

@GenSerializer()
class ChannelSerializer extends Serializer<Channel> with _$ChannelSerializer {}

@GenSerializer(serializers: [ChannelSerializer])
class CandidateSerializer extends Serializer<Candidate>
    with _$CandidateSerializer {}

@GenSerializer()
class ElectionOfficialsSerializer extends Serializer<ElectionOfficials>
    with _$ElectionOfficialsSerializer {}

@GenSerializer(serializers: [
  AddressSerializer,
  ElectionOfficialsSerializer,
  SourceSerializer
])
class ElectionAdministrationBodySerializer
    extends Serializer<ElectionAdministrationBody>
    with _$ElectionAdministrationBodySerializer {}

@GenSerializer()
class ElectionStateSerializer extends Serializer<ElectionState>
    with _$ElectionStateSerializer {}

@GenSerializer()
class ElectionSerializer extends Serializer<Election>
    with _$ElectionSerializer {}

@GenSerializer(
    serializers: [CandidateSerializer, DistrictSerializer, SourceSerializer])
class ContestSerializer extends Serializer<Contest> with _$ContestSerializer {}

@GenSerializer(serializers: [
  AddressSerializer,
  ContestSerializer,
  ElectionAdministrationBodySerializer,
  ElectionOfficialsSerializer,
  ElectionSerializer,
  PollingLocationSerializer,
  ElectionStateSerializer
])
class VoterInfoSerializer extends Serializer<VoterInfo>
    with _$VoterInfoSerializer {}

final repository = new JsonRepo(
    serializers: [RepresentativeInfoSerializer(), VoterInfoSerializer()]);

class JaguarConverter extends Converter {
  const JaguarConverter();

  @override
  Future<Response> decode(Response response, Type responseType) async {
    switch (responseType) {
      case RepresentativeInfo:
        return Response<RepresentativeInfo>(response.base,
            repository.deserialize(response.body, type: responseType));
      case VoterInfo:
        return Response<VoterInfo>(response.base,
            repository.deserialize(response.body, type: responseType));
      default:
        return response;
    }
  }

  @override
  Future<Request> encode(Request request) async =>
      request.replace(body: repository.serialize(request.body));
}
