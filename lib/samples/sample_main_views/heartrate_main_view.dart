import 'package:dtapp_flutter/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;
import 'package:charts_flutter/flutter.dart' as charts;

SamplesApi samplesApi = SamplesApi();

class HeartRateMainView extends StatefulWidget {
  HeartRateMainView(this.otherUser);
  final String otherUser;
  @override
  _HeartRateMainViewState createState() => _HeartRateMainViewState();
}

class _HeartRateMainViewState extends State<HeartRateMainView> {
  // TODO remember to change initial date in the future (DateTime.now())
  DateTime _date = DateTime(2019, 12, 4);

  Future<List<Sample>> _getSamples() async {
    return await samplesApi.samplesGet(
        type: OA.Type.heartRate_,
        startDate: _date.millisecondsSinceEpoch,
        endDate: _date.add(Duration(days: 1)).millisecondsSinceEpoch,
        otherUser: this.widget.otherUser);
  }

  _showDP(BuildContext context) async {
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (selectedDate == null) return;
    setState(() {
      _date = selectedDate;
    });
  }

  @override
  Widget build(BuildContext mainContext) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Selected date"),
              RaisedButton(
                onPressed: () => _showDP(context),
                child: Text("${_date.year}/${_date.month}/${_date.day}"),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _getSamples(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState != ConnectionState.waiting) {
              final samples = snapshot.data as List<Sample>;

              final dataAveragedOnHour = samples
                  .fold<Map<DateTime, List<int>>>({}, (sampleMap, currentMap) {
                    final DateTime dt =
                        DateTime.fromMillisecondsSinceEpoch(currentMap.endDate);
                    final DateTime justDate =
                        DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
                    if (sampleMap[justDate] == null) {
                      sampleMap[justDate] = [0, 0];
                    }
                    sampleMap[justDate][0] += currentMap.value;
                    sampleMap[justDate][1]++;
                    return sampleMap;
                  })
                  .map((k, v) {
                    return MapEntry(
                        k,
                        TimeSeriesHeartRate(
                            k.add(Duration(seconds: 30)), v[0] ~/ v[1]));
                  })
                  .values
                  .toList();

              print("# of samples: " + samples.length.toString());
              return Expanded(
                  child: ContentColumn(
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: SimpleTimeSeriesChart([
                      charts.Series<TimeSeriesHeartRate, DateTime>(
                          id: 'Distance',
                          colorFn: (_, __) =>
                              charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (TimeSeriesHeartRate distance, _) =>
                              distance.time,
                          measureFn: (TimeSeriesHeartRate distance, _) =>
                              distance.heartRate,
                          data: dataAveragedOnHour),
                    ] as List<charts.Series<TimeSeriesHeartRate, DateTime>>),
                  ),
                ],
              ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
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
      domainAxis: new charts.DateTimeAxisSpec(
          tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
        hour: charts.TimeFormatterSpec(format: 'Hm', transitionFormat: 'Hm'),
      )),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickProviderSpec:
              new charts.BasicNumericTickProviderSpec(zeroBound: false)),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
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

class TimeSeriesHeartRate {
  final DateTime time;
  final int heartRate;

  TimeSeriesHeartRate(this.time, this.heartRate);
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
