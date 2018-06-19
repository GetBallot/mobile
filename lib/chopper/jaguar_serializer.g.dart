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

abstract class _$SourceSerializer implements Serializer<Source> {
  @override
  Map<String, dynamic> toMap(Source model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'official', model.official);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  Source fromMap(Map<String, dynamic> map, {Source model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new Source();
    obj.name = map['name'] as String;
    obj.official = map['official'] as bool;
    return obj;
  }

  @override
  String modelString() => 'Source';
}

abstract class _$PollingLocationSerializer
    implements Serializer<PollingLocation> {
  final _addressSerializer = new AddressSerializer();
  final _sourceSerializer = new SourceSerializer();

  @override
  Map<String, dynamic> toMap(PollingLocation model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'id', model.id);
      setNullableValue(
          ret,
          'address',
          _addressSerializer.toMap(model.address,
              withType: withType, typeKey: typeKey));
      setNullableValue(ret, 'notes', model.notes);
      setNullableValue(ret, 'pollingHours', model.pollingHours);
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'voterServices', model.voterServices);
      setNullableValue(ret, 'startDate', model.startDate);
      setNullableValue(ret, 'endDate', model.endDate);
      setNullableValue(
          ret,
          'sources',
          nullableIterableMapper(
              model.sources,
              (val) => _sourceSerializer.toMap(val as Source,
                  withType: withType, typeKey: typeKey)));
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
    obj.id = map['id'] as String;
    obj.address =
        _addressSerializer.fromMap(map['address'] as Map<String, dynamic>);
    obj.notes = map['notes'] as String;
    obj.pollingHours = map['pollingHours'] as String;
    obj.name = map['name'] as String;
    obj.voterServices = map['voterServices'] as String;
    obj.startDate = map['startDate'] as String;
    obj.endDate = map['endDate'] as String;
    obj.sources = nullableIterableMapper<Source>(map['sources'] as Iterable,
        (val) => _sourceSerializer.fromMap(val as Map<String, dynamic>));
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
      setNullableValue(ret, 'id', model.id);
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
    obj.id = map['id'] as String;
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

abstract class _$ElectionOfficialsSerializer
    implements Serializer<ElectionOfficials> {
  @override
  Map<String, dynamic> toMap(ElectionOfficials model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'title', model.title);
      setNullableValue(ret, 'officePhoneNumber', model.officePhoneNumber);
      setNullableValue(ret, 'faxNumber', model.faxNumber);
      setNullableValue(ret, 'emailAddress', model.emailAddress);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  ElectionOfficials fromMap(Map<String, dynamic> map,
      {ElectionOfficials model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new ElectionOfficials();
    obj.name = map['name'] as String;
    obj.title = map['title'] as String;
    obj.officePhoneNumber = map['officePhoneNumber'] as String;
    obj.faxNumber = map['faxNumber'] as String;
    obj.emailAddress = map['emailAddress'] as String;
    return obj;
  }

  @override
  String modelString() => 'ElectionOfficials';
}

abstract class _$ElectionAdministrationBodySerializer
    implements Serializer<ElectionAdministrationBody> {
  final _addressSerializer = new AddressSerializer();
  final _electionOfficialsSerializer = new ElectionOfficialsSerializer();
  final _sourceSerializer = new SourceSerializer();

  @override
  Map<String, dynamic> toMap(ElectionAdministrationBody model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'electionInfoUrl', model.electionInfoUrl);
      setNullableValue(
          ret, 'electionRegistrationUrl', model.electionRegistrationUrl);
      setNullableValue(ret, 'electionRegistrationConfirmationUrl',
          model.electionRegistrationConfirmationUrl);
      setNullableValue(
          ret, 'absenteeVotingInfoUrl', model.absenteeVotingInfoUrl);
      setNullableValue(
          ret, 'votingLocationFinderUrl', model.votingLocationFinderUrl);
      setNullableValue(ret, 'ballotInfoUrl', model.ballotInfoUrl);
      setNullableValue(ret, 'electionRulesUrl', model.electionRulesUrl);
      setNullableValue(ret, 'voter_services',
          nullableIterableMapper(model.voter_services, (val) => val as String));
      setNullableValue(ret, 'hoursOfOperation', model.hoursOfOperation);
      setNullableValue(
          ret,
          'correspondenceAddress',
          _addressSerializer.toMap(model.correspondenceAddress,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'physicalAddress',
          _addressSerializer.toMap(model.physicalAddress,
              withType: withType, typeKey: typeKey));
      setNullableValue(
          ret,
          'electionOfficials',
          nullableIterableMapper(
              model.electionOfficials,
              (val) => _electionOfficialsSerializer.toMap(
                  val as ElectionOfficials,
                  withType: withType,
                  typeKey: typeKey)));
      setNullableValue(
          ret,
          'sources',
          nullableIterableMapper(
              model.sources,
              (val) => _sourceSerializer.toMap(val as Source,
                  withType: withType, typeKey: typeKey)));
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  ElectionAdministrationBody fromMap(Map<String, dynamic> map,
      {ElectionAdministrationBody model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new ElectionAdministrationBody();
    obj.name = map['name'] as String;
    obj.electionInfoUrl = map['electionInfoUrl'] as String;
    obj.electionRegistrationUrl = map['electionRegistrationUrl'] as String;
    obj.electionRegistrationConfirmationUrl =
        map['electionRegistrationConfirmationUrl'] as String;
    obj.absenteeVotingInfoUrl = map['absenteeVotingInfoUrl'] as String;
    obj.votingLocationFinderUrl = map['votingLocationFinderUrl'] as String;
    obj.ballotInfoUrl = map['ballotInfoUrl'] as String;
    obj.electionRulesUrl = map['electionRulesUrl'] as String;
    obj.voter_services = nullableIterableMapper<String>(
        map['voter_services'] as Iterable, (val) => val as String);
    obj.hoursOfOperation = map['hoursOfOperation'] as String;
    obj.correspondenceAddress = _addressSerializer
        .fromMap(map['correspondenceAddress'] as Map<String, dynamic>);
    obj.physicalAddress = _addressSerializer
        .fromMap(map['physicalAddress'] as Map<String, dynamic>);
    obj.electionOfficials = nullableIterableMapper<ElectionOfficials>(
        map['electionOfficials'] as Iterable,
        (val) =>
            _electionOfficialsSerializer.fromMap(val as Map<String, dynamic>));
    obj.sources = nullableIterableMapper<Source>(map['sources'] as Iterable,
        (val) => _sourceSerializer.fromMap(val as Map<String, dynamic>));
    return obj;
  }

  @override
  String modelString() => 'ElectionAdministrationBody';
}

abstract class _$ElectionStateSerializer implements Serializer<ElectionState> {
  @override
  Map<String, dynamic> toMap(ElectionState model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'id', model.id);
      setNullableValue(ret, 'name', model.name);
      setTypeKeyValue(typeKey, modelString(), withType, ret);
    }
    return ret;
  }

  @override
  ElectionState fromMap(Map<String, dynamic> map, {ElectionState model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new ElectionState();
    obj.id = map['id'] as String;
    obj.name = map['name'] as String;
    return obj;
  }

  @override
  String modelString() => 'ElectionState';
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
  final _sourceSerializer = new SourceSerializer();

  @override
  Map<String, dynamic> toMap(Contest model,
      {bool withType: false, String typeKey}) {
    Map<String, dynamic> ret;
    if (model != null) {
      ret = <String, dynamic>{};
      setNullableValue(ret, 'name', model.name);
      setNullableValue(ret, 'type', model.type);
      setNullableValue(ret, 'office', model.office);
      setNullableValue(ret, 'primaryParty', model.primaryParty);
      setNullableValue(
          ret, 'electorateSpecifications', model.electorateSpecifications);
      setNullableValue(ret, 'special', model.special);
      setNullableValue(ret, 'level',
          nullableIterableMapper(model.level, (val) => val as String));
      setNullableValue(ret, 'roles',
          nullableIterableMapper(model.roles, (val) => val as String));
      setNullableValue(
          ret,
          'district',
          _districtSerializer.toMap(model.district,
              withType: withType, typeKey: typeKey));
      setNullableValue(ret, 'numberElected', model.numberElected);
      setNullableValue(ret, 'numberVotingFor', model.numberVotingFor);
      setNullableValue(ret, 'ballotPlacement', model.ballotPlacement);
      setNullableValue(
          ret,
          'candidates',
          nullableIterableMapper(
              model.candidates,
              (val) => _candidateSerializer.toMap(val as Candidate,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(ret, 'referendumTitle', model.referendumTitle);
      setNullableValue(ret, 'referendumSubtitle', model.referendumSubtitle);
      setNullableValue(ret, 'referendumUrl', model.referendumUrl);
      setNullableValue(ret, 'referendumBrief', model.referendumBrief);
      setNullableValue(ret, 'referendumText', model.referendumText);
      setNullableValue(
          ret, 'referendumProStatement', model.referendumProStatement);
      setNullableValue(
          ret, 'referendumConStatement', model.referendumConStatement);
      setNullableValue(
          ret, 'referendumPassageThreshold', model.referendumPassageThreshold);
      setNullableValue(
          ret, 'referendumEffectOfAbstain', model.referendumEffectOfAbstain);
      setNullableValue(
          ret,
          'referendumBallotResponses',
          nullableIterableMapper(
              model.referendumBallotResponses, (val) => val as String));
      setNullableValue(
          ret,
          'sources',
          nullableIterableMapper(
              model.sources,
              (val) => _sourceSerializer.toMap(val as Source,
                  withType: withType, typeKey: typeKey)));
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
    obj.primaryParty = map['primaryParty'] as String;
    obj.electorateSpecifications = map['electorateSpecifications'] as String;
    obj.special = map['special'] as String;
    obj.level = nullableIterableMapper<String>(
        map['level'] as Iterable, (val) => val as String);
    obj.roles = nullableIterableMapper<String>(
        map['roles'] as Iterable, (val) => val as String);
    obj.district =
        _districtSerializer.fromMap(map['district'] as Map<String, dynamic>);
    obj.numberElected = map['numberElected'] as int;
    obj.numberVotingFor = map['numberVotingFor'] as int;
    obj.ballotPlacement = map['ballotPlacement'] as int;
    obj.candidates = nullableIterableMapper<Candidate>(
        map['candidates'] as Iterable,
        (val) => _candidateSerializer.fromMap(val as Map<String, dynamic>));
    obj.referendumTitle = map['referendumTitle'] as String;
    obj.referendumSubtitle = map['referendumSubtitle'] as String;
    obj.referendumUrl = map['referendumUrl'] as String;
    obj.referendumBrief = map['referendumBrief'] as String;
    obj.referendumText = map['referendumText'] as String;
    obj.referendumProStatement = map['referendumProStatement'] as String;
    obj.referendumConStatement = map['referendumConStatement'] as String;
    obj.referendumPassageThreshold =
        map['referendumPassageThreshold'] as String;
    obj.referendumEffectOfAbstain = map['referendumEffectOfAbstain'] as String;
    obj.referendumBallotResponses = nullableIterableMapper<String>(
        map['referendumBallotResponses'] as Iterable, (val) => val as String);
    obj.sources = nullableIterableMapper<Source>(map['sources'] as Iterable,
        (val) => _sourceSerializer.fromMap(val as Map<String, dynamic>));
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
  final _electionStateSerializer = new ElectionStateSerializer();

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
          'earlyVoteSites',
          nullableIterableMapper(
              model.earlyVoteSites,
              (val) => _pollingLocationSerializer.toMap(val as PollingLocation,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(
          ret,
          'dropOffLocations',
          nullableIterableMapper(
              model.dropOffLocations,
              (val) => _pollingLocationSerializer.toMap(val as PollingLocation,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(
          ret,
          'contests',
          nullableIterableMapper(
              model.contests,
              (val) => _contestSerializer.toMap(val as Contest,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(
          ret,
          'state',
          nullableIterableMapper(
              model.state,
              (val) => _electionStateSerializer.toMap(val as ElectionState,
                  withType: withType, typeKey: typeKey)));
      setNullableValue(ret, 'mailOnly', model.mailOnly);
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
    obj.earlyVoteSites = nullableIterableMapper<PollingLocation>(
        map['earlyVoteSites'] as Iterable,
        (val) =>
            _pollingLocationSerializer.fromMap(val as Map<String, dynamic>));
    obj.dropOffLocations = nullableIterableMapper<PollingLocation>(
        map['dropOffLocations'] as Iterable,
        (val) =>
            _pollingLocationSerializer.fromMap(val as Map<String, dynamic>));
    obj.contests = nullableIterableMapper<Contest>(map['contests'] as Iterable,
        (val) => _contestSerializer.fromMap(val as Map<String, dynamic>));
    obj.state = nullableIterableMapper<ElectionState>(map['state'] as Iterable,
        (val) => _electionStateSerializer.fromMap(val as Map<String, dynamic>));
    obj.mailOnly = map['mailOnly'] as bool;
    return obj;
  }

  @override
  String modelString() => 'VoterInfo';
}
