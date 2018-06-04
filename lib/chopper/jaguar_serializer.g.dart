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

abstract class _$VotingAddressSerializer implements Serializer<VotingAddress> {
  @override
  Map<String, dynamic> toMap(VotingAddress model,
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
  VotingAddress fromMap(Map<String, dynamic> map, {VotingAddress model}) {
    if (map == null) {
      return null;
    }
    final obj = model ?? new VotingAddress();
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
  String modelString() => 'VotingAddress';
}

abstract class _$RepresentativeInfoSerializer
    implements Serializer<RepresentativeInfo> {
  final _votingAddressSerializer = new VotingAddressSerializer();
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
          _votingAddressSerializer.toMap(model.normalizedInput,
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
    obj.normalizedInput = _votingAddressSerializer
        .fromMap(map['normalizedInput'] as Map<String, dynamic>);
    obj.divisions = nullableMapMaker<Division>(
        map['divisions'] as Map<String, dynamic>,
        (val) => _divisionSerializer.fromMap(val as Map<String, dynamic>));
    return obj;
  }

  @override
  String modelString() => 'RepresentativeInfo';
}
