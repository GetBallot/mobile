import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final name = station['address']['locationName'];
    final String address = station['formattedAddress'];
    return ListTile(
      trailing: IconButton(
        icon: Icon(Icons.map),
        onPressed: () {
          final url = "https://www.google.com/maps?q=" +
              Uri.encodeQueryComponent(address);
          _launchUrl(url);
        },
      ),
      title: Text(inList && name != null ? name : address),
      subtitle: inList && name != null ? Text(address) : null,
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
    final List<Widget> rows = [];

    final String name = station['address']['locationName'];
    if (name != null) {
      rows.add(getHeader(theme, title: name));
    }

    rows.add(getAddressListTile(context, station, false));

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
