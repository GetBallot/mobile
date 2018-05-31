import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'representative_info.g.dart';

@JsonSerializable()
class RepresentativeInfo extends Object
    with _$RepresentativeInfoSerializerMixin {
  final VotingAddress normalizedInput;
  final LinkedHashMap<String, Division> divisions;

  RepresentativeInfo(this.normalizedInput, this.divisions);

  factory RepresentativeInfo.fromJson(Map<String, dynamic> json) =>
      _$RepresentativeInfoFromJson(json);
}

@JsonSerializable()
class VotingAddress extends Object with _$VotingAddressSerializerMixin {
  final String locationName;
  final String line1;
  final String line2;
  final String line3;
  final String city;
  final String state;
  final String zip;

  VotingAddress(this.locationName, this.line1, this.line2, this.line3,
      this.city, this.state, this.zip);

  factory VotingAddress.fromJson(Map<String, dynamic> json) =>
      _$VotingAddressFromJson(json);
}

@JsonSerializable()
class Division extends Object with _$DivisionSerializerMixin {
  final String name;

  Division(this.name);

  factory Division.fromJson(Map<String, dynamic> json) =>
      _$DivisionFromJson(json);
}
