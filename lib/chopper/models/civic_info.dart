import '../jaguar_serializer.dart';

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

  String toString() {
    final buf = StringBuffer();
    buf.write([line1, line2, line3, city, state]
        .where((s) => s != null && s.trim().length != 0)
        .join(", "));
    if (zip != null) {
      buf.writeAll([" ", zip]);
    }
    return buf.toString().trim();
  }

  static String format(fields) {
    final buf = StringBuffer();
    buf.write(['line1', 'line2', 'line3', 'city', 'state']
        .map((key) => fields[key])
        .where((s) => s != null && s.trim().length != 0)
        .join(", "));
    if (fields['zip'] != null) {
      buf.writeAll([" ", fields['zip']]);
    }
    return buf.toString().trim();
  }
}

class RepresentativeInfo {
  static final _serializer = RepresentativeInfoSerializer();

  Address normalizedInput;
  Map<String, Division> divisions;

  Map serialize() {
    final map = _serializer.serialize(this);
    map["input"] = normalizedInput.toString();
    return map;
  }
}

class Source {
  String name;
  bool official;
}

class PollingLocation {
  String id;
  Address address;
  String notes;
  String pollingHours;
  String name;
  String voterServices;
  String startDate;
  String endDate;
  List<Source> sources;
}

class District {
  String id;
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
  String name;
  String type;
  String office;
  String primaryParty;
  String electorateSpecifications;
  String special;
  List<String> level;
  List<String> roles;
  District district;
  int numberElected;
  int numberVotingFor;
  int ballotPlacement;
  List<Candidate> candidates;
  String referendumTitle;
  String referendumSubtitle;
  String referendumUrl;
  String referendumBrief;
  String referendumText;
  String referendumProStatement;
  String referendumConStatement;
  String referendumPassageThreshold;
  String referendumEffectOfAbstain;
  List<String> referendumBallotResponses;
  List<Source> sources;
}

class ElectionOfficials {
  String name;
  String title;
  String officePhoneNumber;
  String faxNumber;
  String emailAddress;
}

class ElectionAdministrationBody {
  String name;
  String electionInfoUrl;
  String electionRegistrationUrl;
  String electionRegistrationConfirmationUrl;
  String absenteeVotingInfoUrl;
  String votingLocationFinderUrl;
  String ballotInfoUrl;
  String electionRulesUrl;
  List<String> voter_services;
  String hoursOfOperation;
  Address correspondenceAddress;
  Address physicalAddress;
  List<ElectionOfficials> electionOfficials;
  List<Source> sources;
}

class ElectionState {
  String id;
  String name;
}

class Election {
  String id;
  String name;
  String electionDay;
  String ocdDivisionId;
}

class VoterInfo {
  static final _serializer = VoterInfoSerializer();

  Election election;
  Address normalizedInput;
  List<PollingLocation> pollingLocations;
  List<PollingLocation> earlyVoteSites;
  List<PollingLocation> dropOffLocations;
  List<Contest> contests;
  List<ElectionState> state;
  bool mailOnly;

  Map serialize() {
    final map = _serializer.serialize(this);
    map["input"] = normalizedInput.toString();
    return map;
  }
}
