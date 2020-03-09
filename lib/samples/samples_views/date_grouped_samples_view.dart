import 'package:dtapp_flutter/util/date_format.dart';
import 'package:flutter/material.dart';
import 'package:dtapp_flutter/samples/sample_view_select.dart';
import 'package:openapi/api.dart' hide Type;

import '../samples_type_choices.dart';

final samplesapiInstance = SamplesApi();

class DateGroupedSamplesView extends StatefulWidget {
  DateGroupedSamplesView(this.selectedChoice, {Key key}) : super(key: key);
  final TypeChoice selectedChoice;

  @override
  _DateGroupedSamplesViewState createState() => _DateGroupedSamplesViewState();
}

class _DateGroupedSamplesViewState extends State<DateGroupedSamplesView> {
  _DateGroupedSamplesViewState();

  static const MAX_LIMIT = 200;
  List<Sample> _samples = List<Sample>();

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _loadMore();
        }
      });
    super.initState();
  }

  ScrollController _scrollController;

  void _loadMore() {
    setState(() {});
  }

  Future<String> _refresh() {
    _samples.clear();
    setState(() {});
    return Future.value("value doesnt matter ay lmao");
  }

  Future<Map<DateTime, List<Sample>>> _fetchSamplesMapped() async {
    try {
      var samples = await samplesapiInstance.samplesGet(
          offset: _samples.length,
          limit: MAX_LIMIT,
          type: widget.selectedChoice.type);

      _samples.addAll(samples);

      var mapped = _samples.fold<Map<DateTime, List<Sample>>>({},
          (sampleMap, currentMap) {
        final DateTime dt =
            DateTime.fromMillisecondsSinceEpoch(currentMap.endDate);
        final DateTime justDate = DateTime(dt.year, dt.month, dt.day);
        if (sampleMap[justDate] == null) {
          sampleMap[justDate] = [];
        }
        sampleMap[justDate].add(currentMap);
        return sampleMap;
      });

      /*
    mapped.forEach((e, v){
        print(e.value + ":" + v.length.toString());
        v.forEach((a){
          print('\t' + a.value.toString());
        });
    });
    */

      print("Samples retrieved " + samples.length.toString());
      return mapped;
    } catch (e) {
      print("samples error");
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchSamplesMapped(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext ibContext, int index) {
                      DateTime key = data.keys.elementAt(index);
                      List<Sample> values = data.values.elementAt(index);
                      //return Text("test");
                      return Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Column(children: <Widget>[
                            ExpansionTile(
                              title: Text(formatDateFull(key)),
                              children: <Widget>[
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: values.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext ibContext, int index_2) {
                                      Sample sample = values[index_2];
                                      final color = Colors.white;
                                      // Colors.blue[100 - 50 * (index_2 % 2)];
                                      return Column(children: [
                                        selectSampleView(context, sample.type,
                                            sample, color),
                                        if (index_2 < values.length - 1)
                                          Container(
                                              decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[300],
                                                  width: 2.0),
                                            ),
                                          )),
                                      ]);
                                    })
                              ],
                              initiallyExpanded: true,
                            )
                          ]));
                    }));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
