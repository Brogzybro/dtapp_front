import 'package:dtapp_flutter/custom_widgets/custom_widgets.dart';
import 'package:dtapp_flutter/model/ecg.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;
import 'package:charts_flutter/flutter.dart' as charts;

SamplesApi samplesApi = SamplesApi();

class ECGMainView extends StatefulWidget {
  @override
  _ECGMainViewState createState() => _ECGMainViewState();
}

class ECGNavigator {
  var current = 0;

  void next() {
    if (current > 0) current--;
  }

  void previous() {
    current++;
  }
}

class _ECGMainViewState extends State<ECGMainView> {
  ECGNavigator _nav = ECGNavigator();

  Future<List<Sample>> _getLastSample() async {
    print(_nav.current);
    return await samplesApi.samplesGet(
      type: OA.Type.ecg_,
      limit: 1,
      offset: _nav.current,
    );
  }

  _leftTap() {
    _nav.previous();
    setState(() {});
  }

  _rightTap() {
    _nav.next();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ContentColumn(
      children: <Widget>[
        FutureBuilder(
          future: _getLastSample(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              final samples = snapshot.data as List<Sample>;

              final date = samples.isNotEmpty
                  ? DateTime.fromMillisecondsSinceEpoch(samples.first.startDate)
                  : null;
              final data = samples.isNotEmpty
                  ? ECG
                      .fromJson(samples.first.value)
                      .signal
                      .asMap()
                      .entries
                      .map((entry) {
                      return SeriesECG(entry.key, entry.value);
                    }).toList()
                  : List<SeriesECG>();
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 400,
                    child: (snapshot.connectionState != ConnectionState.waiting)
                        ? charts.LineChart(
                            [
                              charts.Series<SeriesECG, int>(
                                id: 'ECG',
                                colorFn: (_, __) =>
                                    charts.MaterialPalette.blue.shadeDefault,
                                domainFn: (SeriesECG ecg, _) => ecg.interval,
                                measureFn: (SeriesECG ecg, _) => ecg.voltage,
                                data: data,
                              )
                            ] as List<charts.Series<dynamic, num>>,
                            animate: false,
                            behaviors: [new charts.PanAndZoomBehavior()],
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _leftTap,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 60,
                        ),
                      ),
                      Column(
                        children: (date != null
                            ? [
                                Text(
                                  "${date.day}/${date.month}/${date.year}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "${date.hour}:${date.minute}:${date.second}",
                                ),
                              ]
                            : [
                                Text(
                                  "End",
                                  style: TextStyle(fontSize: 20),
                                )
                              ])
                          ..add(Text(_nav.current.toString())),
                      ),
                      GestureDetector(
                        onTap: _rightTap,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                  if (samples.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.only(
                            left: 50, right: 50, top: 20, bottom: 20),
                        child: CustomTable.withColor(title: "About", children: [
                          CustomRowData(
                            Text("Sample frequency"),
                            ECG
                                .fromJson(samples.first.value)
                                .sampling_frequency
                                .toString(),
                          ),
                          CustomRowData(
                            Text("Wear position"),
                            ECG
                                .fromJson(samples.first.value)
                                .wearposition
                                .toString(),
                          )
                        ]))
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }
}

class SeriesECG {
  final int interval;
  final int voltage;

  SeriesECG(this.interval, this.voltage);
}
