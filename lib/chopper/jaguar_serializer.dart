import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import "models/representative_info.dart";

part "jaguar_serializer.g.dart";

@GenSerializer()
class DivisionSerializer extends Serializer<Division>
    with _$DivisionSerializer {}

@GenSerializer()
class VotingAddressSerializer extends Serializer<VotingAddress>
    with _$VotingAddressSerializer {}

@GenSerializer(serializers: [VotingAddressSerializer, DivisionSerializer])
class RepresentativeInfoSerializer extends Serializer<RepresentativeInfo>
    with _$RepresentativeInfoSerializer {}

final repository = new JsonRepo(serializers: [RepresentativeInfoSerializer()]);

class JaguarConverter extends Converter {
  const JaguarConverter();

  @override
  Future<Response> decode(Response response, Type responseType) async {
    switch (responseType) {
      case RepresentativeInfo:
        return Response<RepresentativeInfo>(response.base,
            repository.deserialize(response.body, type: responseType));
      default:
        return response;
    }
  }

  @override
  Future<Request> encode(Request request) async =>
      request.replace(body: repository.serialize(request.body));
}
