import 'package:dtapp_flutter/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;
import 'package:charts_flutter/flutter.dart' as charts;

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

    return await samplesApi.samplesGet(
        startDate: ninetyDaysAgo, type: DISTANCE_TYPE);
  }

  DistanceState _calcLastDistances(List<Sample> samples) {
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
  }

  Map<DateTime, double> _distanceGroupedByDate(List<Sample> samples) {
    return samples.fold<Map<DateTime, double>>({}, (sampleMap, currentMap) {
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
    return FutureBuilder(
      future: _getSamples(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data as List<Sample>;
          final distanceState = _calcLastDistances(data);
          final distanceGroupedByDate = _distanceGroupedByDate(data);
          return ContentColumn(children: <Widget>[
            CustomTable.withColor(
              title: "Summary",
              color: Colors.blue,
              shade: CustomShade.shade0,
              children: <CustomRowData>[
                CustomRowData(
                  Text("Last 24 hours"),
                  _distanceToReadable(distanceState.totalLast24Hours),
                ),
                CustomRowData(
                  Text("Last 7 days"),
                  _distanceToReadable(distanceState.totalLast7Days),
                ),
                CustomRowData(
                  Text("Last 30 days"),
                  _distanceToReadable(distanceState.totalLast30Days),
                ),
                CustomRowData(
                  Text("Last 90 days"),
                  _distanceToReadable(distanceState.totalLast90Days),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: TimeSeriesBar(
                [
                  charts.Series<TimeSeriesDistance, DateTime>(
                      id: 'Distance',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (TimeSeriesDistance distance, _) =>
                          distance.time,
                      measureFn: (TimeSeriesDistance distance, _) =>
                          distance.distance,
                      data: distanceGroupedByDate
                          .map((k, v) {
                            return MapEntry(
                                k, TimeSeriesDistance(k, (v * 1000).toInt()));
                          })
                          .values
                          .toList()),
                ] as List<charts.Series<TimeSeriesDistance, DateTime>>,
              ),
            ),
            CustomTable.withColor(
              title: "Distance walked on day",
              color: Colors.teal,
              shade: CustomShade.shade0,
              children: distanceGroupedByDate
                  .map((k, v) => MapEntry(
                      k,
                      CustomRowData(Text("${k.year}/${k.month}/${k.day}"),
                          _distanceToReadable(v))))
                  .values
                  .toList(),
            )
          ]);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
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

class SimpleTimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleTimeSeriesChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory SimpleTimeSeriesChart.withSampleData() {
    return new SimpleTimeSeriesChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime(2017, 9, 19), 5),
      TimeSeriesSales(DateTime(2017, 9, 26), 25),
      TimeSeriesSales(DateTime(2017, 10, 3), 100),
      TimeSeriesSales(DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class TimeSeriesDistance {
  final DateTime time;
  final int distance;

  TimeSeriesDistance(this.time, this.distance);
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesBar(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesBar.withSampleData() {
    return new TimeSeriesBar(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 1), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 2), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 3), 25),
      new TimeSeriesSales(new DateTime(2017, 9, 4), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 5), 75),
      new TimeSeriesSales(new DateTime(2017, 9, 6), 88),
      new TimeSeriesSales(new DateTime(2017, 9, 7), 65),
      new TimeSeriesSales(new DateTime(2017, 9, 8), 91),
      new TimeSeriesSales(new DateTime(2017, 9, 9), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 10), 111),
      new TimeSeriesSales(new DateTime(2017, 9, 11), 90),
      new TimeSeriesSales(new DateTime(2017, 9, 12), 50),
      new TimeSeriesSales(new DateTime(2017, 9, 13), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 14), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 15), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 16), 50),
      new TimeSeriesSales(new DateTime(2017, 9, 17), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 18), 35),
      new TimeSeriesSales(new DateTime(2017, 9, 19), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 20), 32),
      new TimeSeriesSales(new DateTime(2017, 9, 21), 31),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
