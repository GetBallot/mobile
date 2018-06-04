class Division {
  String name;
}

class Address {
  String locationName;
  String line1;
  String line2;
  String line3;
  String city;
  String state;
  String zip;
}

class RepresentativeInfo {
  Address normalizedInput;
  Map<String, Division> divisions;
}

class PollingLocation {
  Address address;
}

class District {
  String name;
  String scope;
}

class Channel {
  String type;
  String id;
}

class Candidate {
  String name;
  String party;
  String candidateUrl;
  String phone;
  String photoUrl;
  String email;
  int orderOnBallot;
  List<Channel> channels;
}

class Contest {
  String type;
  String office;
  List<String> level;
  District district;
  List<Candidate> candidates;
  String referendumTitle;
  String referendumSubtitle;
  String referendumText;
  List<String> referendumBallotResponses;
}

class VoterInfo {
  Address normalizedInput;
  List<PollingLocation> pollingLocations;
  List<Contest> contests;
}
