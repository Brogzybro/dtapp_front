import 'package:dtapp_flutter/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

SamplesApi samplesApi = SamplesApi();

class DistanceMainView extends StatefulWidget {
  @override
  _DistanceMainViewState createState() => _DistanceMainViewState();
}

class DistanceState {
  DistanceState(this.totalLast24Hours, this.totalLast7Days,
      this.totalLast30Days, this.totalLast90Days);
  final double totalLast24Hours;
  final double totalLast7Days;
  final double totalLast30Days;
  final double totalLast90Days;
}

class _DistanceMainViewState extends State<DistanceMainView> {
  static const DISTANCE_TYPE = OA.Type.distance_;
  List<Sample> _samples = List<Sample>();
  static DateTime _now = DateTime.utc(2019, 12, 5, 18);

  // Input: distance as kilometers
  static String _distanceToReadable(double distance) {
    return distance < 1
        ? (distance * 1000).toStringAsFixed(0) + " m"
        : distance.toStringAsFixed(2) + " km";
  }

  Future<List<Sample>> _getSamples() async {
    final now = DateTime.utc(2019, 12, 5, 18);
    final ninetyDaysAgo =
        now.subtract(Duration(days: 90)).millisecondsSinceEpoch;

    if (_samples.length == 0)
      _samples.addAll(await samplesApi.samplesGet(
          startDate: ninetyDaysAgo, type: DISTANCE_TYPE));

    return _samples;
  }

  Future<DistanceState> _fetchDistances() async {
    try {
      final samples = await _getSamples();

      print("DISTANCE - Samples retrieved: " + samples.length.toString());
      return DistanceState(
        samples
            .where((sample) =>
                sample.startDate >
                _now.subtract(Duration(days: 1)).millisecondsSinceEpoch)
            .map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).fold(0, (value, element) => value + element),
        samples
            .where((sample) =>
                sample.startDate >
                _now.subtract(Duration(days: 7)).millisecondsSinceEpoch)
            .map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).fold(0, (value, element) => value + element),
        samples
            .where((sample) =>
                sample.startDate >
                _now.subtract(Duration(days: 30)).millisecondsSinceEpoch)
            .map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).fold(0, (value, element) => value + element),
        samples.map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).reduce((value, element) => value + element),
      );
    } catch (e) {
      print("fetchDistance error");
      print(e);
      return null;
    }
  }

  Future<Map<DateTime, double>> _fetchDistancesGroupedByDays() async {
    return (await _getSamples()).fold<Map<DateTime, double>>({},
        (sampleMap, currentMap) {
      final DateTime dt =
          DateTime.fromMillisecondsSinceEpoch(currentMap.endDate);
      final DateTime justDate = DateTime(dt.year, dt.month, dt.day);
      if (sampleMap[justDate] == null) {
        sampleMap[justDate] = 0;
      }
      sampleMap[justDate] += currentMap.value;
      return sampleMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentColumn(children: <Widget>[
      FutureBuilder(
        future: _fetchDistances(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as DistanceState;
            return CustomTable.withColor(
              title: "Summary",
              color: Colors.grey,
              shade: CustomShade.shade2,
              children: <CustomRowData>[
                CustomRowData(
                  Text("Last 24 hours"),
                  _distanceToReadable(data.totalLast24Hours),
                ),
                CustomRowData(
                  Text("Last 7 days"),
                  _distanceToReadable(data.totalLast7Days),
                ),
                CustomRowData(
                  Text("Last 30 days"),
                  _distanceToReadable(data.totalLast30Days),
                ),
                CustomRowData(
                  Text("Last 90 days"),
                  _distanceToReadable(data.totalLast90Days),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      FutureBuilder(
        future: _fetchDistancesGroupedByDays(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as Map<DateTime, double>;
            return CustomTable.withColor(
              title: "Distance walked on day",
              color: Colors.teal,
              shade: CustomShade.shade0,
              children: data
                  .map((k, v) => MapEntry(
                      k,
                      CustomRowData(Text("${k.year}/${k.month}/${k.day}"),
                          _distanceToReadable(v))))
                  .values
                  .toList(),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ]);
  }
}

class ContentColumn extends StatelessWidget {
  ContentColumn({@required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
          children: children
              .map((child) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: child,
                  ))
              .toList()),
    );
  }
}
