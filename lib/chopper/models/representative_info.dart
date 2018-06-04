class Division {
  String name;
}

class VotingAddress {
  String locationName;
  String line1;
  String line2;
  String line3;
  String city;
  String state;
  String zip;
}

class RepresentativeInfo {
  VotingAddress normalizedInput;
  Map<String, Division> divisions;
}
