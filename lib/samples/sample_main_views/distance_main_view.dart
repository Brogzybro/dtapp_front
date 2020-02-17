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
  Sample test;

  // Input: distance as kilometers
  static String _distanceToReadable(double distance) {
    return distance < 1
        ? (distance * 1000).toStringAsFixed(0) + " m"
        : distance.toStringAsFixed(2) + " km";
  }

  Future<DistanceState> _fetchDistances() async {
    try {
      final now = DateTime.now().subtract(Duration(days: 73));
      print(now);
      final ninetyDaysAgo =
          now.subtract(Duration(days: 90)).millisecondsSinceEpoch;
      print(now);
      final samples = await samplesApi.samplesGet(
          startDate: ninetyDaysAgo, type: DISTANCE_TYPE);

      print("DISTANCE - Samples retrieved: " + samples.length.toString());
      return DistanceState(
        samples
            .where((sample) =>
                sample.startDate >
                now.subtract(Duration(days: 1)).millisecondsSinceEpoch)
            .map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).fold(0, (value, element) => value + element),
        samples
            .where((sample) =>
                sample.startDate >
                now.subtract(Duration(days: 7)).millisecondsSinceEpoch)
            .map((sample) {
          print(sample.value.runtimeType);
          return sample.value;
        }).fold(0, (value, element) => value + element),
        samples
            .where((sample) =>
                sample.startDate >
                now.subtract(Duration(days: 30)).millisecondsSinceEpoch)
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchDistances(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as DistanceState;
          return Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Distance traveled",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Text(
                            "Summary",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                    ),
                    Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.grey[400]),
                      ),
                      children: <TableRow>[
                        customRow(
                          left: Text("Last 24 hours"),
                          right:
                              Text(_distanceToReadable(data.totalLast24Hours)),
                          color: Colors.grey[300],
                        ),
                        customRow(
                          left: Text("Last 7 days"),
                          right: Text(_distanceToReadable(data.totalLast7Days)),
                          color: Colors.grey[300],
                        ),
                        customRow(
                          left: Text("Last 30 days"),
                          right:
                              Text(_distanceToReadable(data.totalLast30Days)),
                          color: Colors.grey[300],
                        ),
                        customRow(
                          left: Text("Last 90 days"),
                          right:
                              Text(_distanceToReadable(data.totalLast90Days)),
                          color: Colors.grey[300],
                          last: true,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Center(child:CircularProgressIndicator());
      },
    );
  }
}

TableRow customRow(
    {@required Text left,
    @required Text right,
    @required Color color,
    bool last = false}) {
  return TableRow(
    decoration: BoxDecoration(
        color: color,
        borderRadius: last
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            : null),
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: left,
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: right,
      ),
    ],
  );
}
