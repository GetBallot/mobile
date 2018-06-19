import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chopper/models/civic_info.dart';
import 'localizations.dart';
import 'widgets.dart';

class PollingStationsPage extends StatelessWidget {
  final List stations;
  PollingStationsPage(this.stations);

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BallotLocalizations.of(context).votingLocationsTitle),
      ),
      body: _createList(),
    );
  }

  Widget _createList() {
    return ListView.builder(
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
          return PollingStationPage.getAddressHeader(context, station);
        });
  }

  static List<Map> getMerged(Map election) {
    final stations = LinkedHashMap<String, Map>();
    if (election == null) {
      return [];
    }

    if (election['pollingStations'] != null) {
      election['pollingStations'].forEach((station) {
        _addStation(stations, station, 'pollingStation');
      });
    }

    if (election['dropOffLocations'] != null) {
      election['dropOffLocations'].forEach((station) {
        _addStation(stations, station, 'dropOffLocation');
      });
    }

    if (election['earlyVoteSites'] != null) {
      election['earlyVoteSites'].forEach((station) {
        _addStation(stations, station, 'earlyVoteSite');
      });
    }

    return stations.values.toList();
  }

  static void _addStation(stations, station, type) {
    if (station['address'] == null) {
      return;
    }

    final locationName = station['address']['locationName'];
    final String address = Address.format(station['address']);
    final key = locationName == null ? address : locationName + ', ' + address;

    if (stations[key] == null) {
      stations[key] = {
        'id': station['id'],
        'address': station['address'],
      };
    }
    stations[key][type] = station;
    stations[key][type].remove('id');
    stations[key][type].remove('address');
  }
}

class PollingStationPage extends StatelessWidget {
  final Map station;

  PollingStationPage(this.station);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(BallotLocalizations.of(context).votingLocationTitle),
        ),
        body: getWidget(context, station),
      );

  static Widget getAddressListTile(context, station, bool inList) {
    final String address = Address.format(station['address']);
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.map),
        onPressed: () {
          final url = "https://www.google.com/maps?q=" +
              Uri.encodeQueryComponent(address);
          _launchUrl(url);
        },
      ),
      title: inList ? Text(station['address']['locationName']) : Text(address),
      subtitle: inList ? Text(address) : null,
    );
  }

  static Widget getAddressHeader(context, station) {
    return GestureDetector(
        child: getAddressListTile(context, station, true),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PollingStationPage(station),
              ));
        });
  }

  static Widget getWidget(context, station) {
    final theme = Theme.of(context);
    final List<Widget> rows = [
      getHeader(theme, text: station['address']['locationName']),
      getAddressListTile(context, station, false),
    ];

    _addInfoRow(rows, station, 'pollingStation', 'pollingHours',
        BallotLocalizations.of(context).pollingStationHoursLabel);
    _addDatesRow(rows, station, 'pollingStation',
        BallotLocalizations.of(context).pollingStationDatesLabel);
    _addInfoRow(rows, station, 'earlyVoteSite', 'pollingHours',
        BallotLocalizations.of(context).earlyVoteSiteHoursLabel);
    _addDatesRow(rows, station, 'earlyVoteSite',
        BallotLocalizations.of(context).earlyVoteSiteDatesLabel);
    _addInfoRow(rows, station, 'dropOffLocation', 'pollingHours',
        BallotLocalizations.of(context).dropOffHoursLabel);
    _addDatesRow(rows, station, 'dropOffLocation',
        BallotLocalizations.of(context).dropOffDatesLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  static void _addInfoRow(rows, station, type, key, label) {
    if (station[type] != null) {
      if (station[type][key] != null) {
        rows.add(ListTile(
            title: Text(label),
            subtitle: Text(
              station[type][key],
            )));
      }
    }
  }

  static void _addDatesRow(rows, station, type, label) {
    if (station[type] == null) {
      return;
    }
    final startDate = station[type]['startDate'];
    final endDate = station[type]['endDate'];
    if (startDate == null || endDate == null) {
      return;
    }
    rows.add(ListTile(
        title: Text(label), subtitle: Text([startDate, endDate].join(' - '))));
  }

  static void _launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
