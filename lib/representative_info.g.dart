// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'representative_info.dart';

// **************************************************************************
// Generator: JsonSerializableGenerator
// **************************************************************************

RepresentativeInfo _$RepresentativeInfoFromJson(Map<String, dynamic> json) =>
    new RepresentativeInfo(
        json['normalizedInput'] == null
            ? null
            : new VotingAddress.fromJson(
                json['normalizedInput'] as Map<String, dynamic>),
        json['divisions'] == null
            ? null
            : new Map<String, Division>.fromIterables(
                (json['divisions'] as Map<String, dynamic>).keys,
                (json['divisions'] as Map).values.map((e) => e == null
                    ? null
                    : new Division.fromJson(e as Map<String, dynamic>))));

abstract class _$RepresentativeInfoSerializerMixin {
  VotingAddress get normalizedInput;
  LinkedHashMap<String, Division> get divisions;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'normalizedInput': normalizedInput,
        'divisions': divisions
      };
}

VotingAddress _$VotingAddressFromJson(Map<String, dynamic> json) =>
    new VotingAddress(
        json['locationName'] as String,
        json['line1'] as String,
        json['line2'] as String,
        json['line3'] as String,
        json['city'] as String,
        json['state'] as String,
        json['zip'] as String);

abstract class _$VotingAddressSerializerMixin {
  String get locationName;
  String get line1;
  String get line2;
  String get line3;
  String get city;
  String get state;
  String get zip;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'locationName': locationName,
        'line1': line1,
        'line2': line2,
        'line3': line3,
        'city': city,
        'state': state,
        'zip': zip
      };
}

Division _$DivisionFromJson(Map<String, dynamic> json) =>
    new Division(json['name'] as String);

abstract class _$DivisionSerializerMixin {
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'name': name};
}
