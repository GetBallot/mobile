// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jaguar_serializer.dart';

// **************************************************************************
// Generator: JaguarSerializerGenerator
// **************************************************************************

abstract class _$DivisionSerializer implements Serializer<Division> {
  @override
  Map<String, dynamic> toMap(Division model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Division fromMap(Map<String, dynamic> map, {Division model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Division();
    obj.name = map['name'] as String;
    return obj;
  }

  @override
  String modelString() => 'Division';
}

abstract class _$AddressSerializer implements Serializer<Address> {
  @override
  Map<String, dynamic> toMap(Address model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'locationName', model.locationName);
      setNullableValue(ret, 'line1', model.line1);
      setNullableValue(ret, 'line2', model.line2);
      setNullableValue(ret, 'line3', model.line3);
      setNullableValue(ret, 'city', model.city);
      setNullableValue(ret, 'state', model.state);
      setNullableValue(ret, 'zip', model.zip);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Address fromMap(Map<String, dynamic> map, {Address model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Address();
    obj.locationName = map['locationName'] as String;
    obj.line1 = map['line1'] as String;
    obj.line2 = map['line2'] as String;
    obj.line3 = map['line3'] as String;
    obj.city = map['city'] as String;
    obj.state = map['state'] as String;
    obj.zip = map['zip'] as String;
    return obj;
  }

  @override
  String modelString() => 'Address';
}

abstract class _$RepresentativeInfoSerializer
    implements Serializer<RepresentativeInfo> {
  final _addressSerializer = new AddressSerializer();
  final _divisionSerializer = new DivisionSerializer();

  @override
  Map<String, dynamic> toMap(RepresentativeInfo model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(
          ret,
          'normalizedInput',
          _addressSerializer.toMap(model.normalizedInput,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'divisions',
          nullableMapMaker(
              model.divisions,
              (val) => _divisionSerializer.toMap(val as Division,
                  withType: withType, typeKey: typeKey)));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  RepresentativeInfo fromMap(Map<String, dynamic> map,
      {RepresentativeInfo model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new RepresentativeInfo();
    obj.normalizedInput = _addressSerializer
        .fromMap(map['normalizedInput'] as Map<String, dynamic>);
    obj.divisions = nullableMapMaker<Division>(
        map['divisions'] as Map<String, dynamic>,
        (val) => _divisionSerializer.fromMap(val as Map<String, dynamic>));
    return obj;
  }

  @override
  String modelString() => 'RepresentativeInfo';
}

abstract class _$PollingLocationSerializer
    implements Serializer<PollingLocation> {
  final _addressSerializer = new AddressSerializer();

  @override
  Map<String, dynamic> toMap(PollingLocation model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(
          ret,
          'address',
          _addressSerializer.toMap(model.address,
              withType: withType, typeKey: typeKey));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  PollingLocation fromMap(Map<String, dynamic> map, {PollingLocation model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new PollingLocation();
    obj.address =
        _addressSerializer.fromMap(map['address'] as Map<String, dynamic>);
    return obj;
  }

  @override
  String modelString() => 'PollingLocation';
}

abstract class _$DistrictSerializer implements Serializer<District> {
  @override
  Map<String, dynamic> toMap(District model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'scope', model.scope);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  District fromMap(Map<String, dynamic> map, {District model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new District();
    obj.name = map['name'] as String;
    obj.scope = map['scope'] as String;
    return obj;
  }

  @override
  String modelString() => 'District';
}

abstract class _$ChannelSerializer implements Serializer<Channel> {
  @override
  Map<String, dynamic> toMap(Channel model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'type', model.type);
      setNullableValue(ret, 'id', model.id);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Channel fromMap(Map<String, dynamic> map, {Channel model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Channel();
    obj.type = map['type'] as String;
    obj.id = map['id'] as String;
    return obj;
  }

  @override
  String modelString() => 'Channel';
}

abstract class _$CandidateSerializer implements Serializer<Candidate> {
  final _channelSerializer = new ChannelSerializer();

  @override
  Map<String, dynamic> toMap(Candidate model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'party', model.party);
      setNullableValue(ret, 'candidateUrl', model.candidateUrl);
      setNullableValue(ret, 'phone', model.phone);
      setNullableValue(ret, 'photoUrl', model.photoUrl);
      setNullableValue(ret, 'email', model.email);
      setNullableValue(ret, 'orderOnBallot', model.orderOnBallot);
      setNullableValue(
          ret,
          'channels',
          nullableIterableMapper(
              model.channels,
              (val) => _channelSerializer.toMap(val as Channel,
                  withType: withType, typeKey: typeKey)));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Candidate fromMap(Map<String, dynamic> map, {Candidate model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Candidate();
    obj.name = map['name'] as String;
    obj.party = map['party'] as String;
    obj.candidateUrl = map['candidateUrl'] as String;
    obj.phone = map['phone'] as String;
    obj.photoUrl = map['photoUrl'] as String;
    obj.email = map['email'] as String;
    obj.orderOnBallot = map['orderOnBallot'] as int;
    obj.channels = nullableIterableMapper<Channel>(map['channels'] as Iterable,
        (val) => _channelSerializer.fromMap(val as Map<String, dynamic>));
    return obj;
  }

  @override
  String modelString() => 'Candidate';
}

abstract class _$ElectionSerializer implements Serializer<Election> {
  @override
  Map<String, dynamic> toMap(Election model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'id', model.id);
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'electionDay', model.electionDay);
      setNullableValue(ret, 'ocdDivisionId', model.ocdDivisionId);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Election fromMap(Map<String, dynamic> map, {Election model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Election();
    obj.id = map['id'] as String;
    obj.name = map['name'] as String;
    obj.electionDay = map['electionDay'] as String;
    obj.ocdDivisionId = map['ocdDivisionId'] as String;
    return obj;
  }

  @override
  String modelString() => 'Election';
}

abstract class _$ContestSerializer implements Serializer<Contest> {
  final _districtSerializer = new DistrictSerializer();
  final _candidateSerializer = new CandidateSerializer();

  @override
  Map<String, dynamic> toMap(Contest model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'type', model.type);
      setNullableValue(ret, 'office', model.office);
      setNullableValue(ret, 'level',
          nullableIterableMapper(model.level, (val) => val as String));
      setNullableValue(
          ret,
          'district',
          _districtSerializer.toMap(model.district,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'candidates',
          nullableIterableMapper(
              model.candidates,
              (val) => _candidateSerializer.toMap(val as Candidate,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(ret, 'referendumTitle', model.referendumTitle);
      setNullableValue(ret, 'referendumSubtitle', model.referendumSubtitle);
      setNullableValue(ret, 'referendumText', model.referendumText);
      setNullableValue(
          ret,
          'referendumBallotResponses',
          nullableIterableMapper(
              model.referendumBallotResponses, (val) => val as String));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Contest fromMap(Map<String, dynamic> map, {Contest model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Contest();
    obj.name = map['name'] as String;
    obj.type = map['type'] as String;
    obj.office = map['office'] as String;
    obj.level = nullableIterableMapper<String>(
        map['level'] as Iterable, (val) => val as String);
    obj.district =
        _districtSerializer.fromMap(map['district'] as Map<String, dynamic>);
    obj.candidates = nullableIterableMapper<Candidate>(
        map['candidates'] as Iterable,
        (val) => _candidateSerializer.fromMap(val as Map<String, dynamic>));
    obj.referendumTitle = map['referendumTitle'] as String;
    obj.referendumSubtitle = map['referendumSubtitle'] as String;
    obj.referendumText = map['referendumText'] as String;
    obj.referendumBallotResponses = nullableIterableMapper<String>(
        map['referendumBallotResponses'] as Iterable, (val) => val as String);
    return obj;
  }

  @override
  String modelString() => 'Contest';
}

abstract class _$VoterInfoSerializer implements Serializer<VoterInfo> {
  final _electionSerializer = new ElectionSerializer();
  final _addressSerializer = new AddressSerializer();
  final _pollingLocationSerializer = new PollingLocationSerializer();
  final _contestSerializer = new ContestSerializer();

  @override
  Map<String, dynamic> toMap(VoterInfo model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(
          ret,
          'election',
          _electionSerializer.toMap(model.election,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'normalizedInput',
          _addressSerializer.toMap(model.normalizedInput,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'pollingLocations',
          nullableIterableMapper(
              model.pollingLocations,
              (val) => _pollingLocationSerializer.toMap(val as PollingLocation,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(
          ret,
          'contests',
          nullableIterableMapper(
              model.contests,
              (val) => _contestSerializer.toMap(val as Contest,
                  withType: withType, typeKey: typeKey)));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  VoterInfo fromMap(Map<String, dynamic> map, {VoterInfo model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new VoterInfo();
    obj.election =
        _electionSerializer.fromMap(map['election'] as Map<String, dynamic>);
    obj.normalizedInput = _addressSerializer
        .fromMap(map['normalizedInput'] as Map<String, dynamic>);
    obj.pollingLocations = nullableIterableMapper<PollingLocation>(
        map['pollingLocations'] as Iterable,
        (val) =>
            _pollingLocationSerializer.fromMap(val as Map<String, dynamic>));
    obj.contests = nullableIterableMapper<Contest>(map['contests'] as Iterable,
        (val) => _contestSerializer.fromMap(val as Map<String, dynamic>));
    return obj;
  }

  @override
  String modelString() => 'VoterInfo';
}
