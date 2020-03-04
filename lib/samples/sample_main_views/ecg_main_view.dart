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

class SampleOffset {
  SampleOffset(this.sample, this.offset);

  final Sample sample;
  final int offset;
}

class ECGNavigator {
  int _offset = 0;

  int get offset {
    return _offset;
  }

  set offset(off) {
    _offset = off;
  }

  void next() {
    _offset++;
  }

  void previous() {
    if (_offset > 0) _offset--;
  }
}

class _ECGMainViewState extends State<ECGMainView> {
  ECGNavigator _nav = ECGNavigator();
  SampleOffset _lastSample;

  Future<SampleOffset> _getLastSample() async {
    print(_nav.offset);
    var samples = await samplesApi.samplesGet(
      type: OA.Type.ecg_,
      limit: 1,
      offset: _nav.offset,
    );
    return (samples.isNotEmpty)
        ? SampleOffset(samples.first, _nav.offset)
        : SampleOffset(null, null);
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
              var sampleO = snapshot.data as SampleOffset;

              if (sampleO.sample == null) {
                sampleO = _lastSample;
                _nav.offset = _lastSample.offset;
              } else {
                _lastSample = sampleO;
              }

              Sample sample = (sampleO.sample == null) ? null : sampleO.sample;
              ECG ecg = ECG.fromJson(sample.value);

              final date = (sample != null)
                  ? DateTime.fromMillisecondsSinceEpoch(sample.startDate)
                  : null;
              final data = (sample != null && ecg.signal != null)
                  ? ecg.signal.asMap().entries.map((entry) {
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
                          ..add(Text(_nav.offset.toString())),
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
                  if (sample != null)
                    Padding(
                        padding: EdgeInsets.only(
                            left: 50, right: 50, top: 20, bottom: 20),
                        child: CustomTable.withColor(title: "About", children: [
                          CustomRowData(
                            Text("Sample frequency"),
                            ECG
                                .fromJson(sample.value)
                                .sampling_frequency
                                .toString(),
                          ),
                          CustomRowData(
                            Text("Wear position"),
                            ECG.fromJson(sample.value).wearposition.toString(),
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
