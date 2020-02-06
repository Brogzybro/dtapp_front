import 'package:flutter/material.dart';
import 'package:dtapp_flutter/home_page.dart';
import 'package:dtapp_flutter/samples/sample_views/_sampleViewSelect.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;
import 'package:dtapp_flutter/samples_page.dart' show TypeChoice;

import '../samples_type_choices.dart';

final samplesapiInstance = SamplesApi();

class DateGroupedSamplesView extends StatefulWidget{
  DateGroupedSamplesView(this.selectedChoice, {Key key}) : super(key: key);
  final TypeChoice selectedChoice;

  @override
  _DateGroupedSamplesViewState createState() => _DateGroupedSamplesViewState();

}

class _DateGroupedSamplesViewState extends State<DateGroupedSamplesView> {
  _DateGroupedSamplesViewState();

  Future<Map<DateTime, List<Sample>>> _fetchSamplesMapped() async {
  try{
    var samples = await samplesapiInstance.samplesGet(limit: 200, type: widget.selectedChoice.type);
    
    var mapped = samples.fold<Map<DateTime, List<Sample>>>({}, (sampleMap, currentMap) {
      final DateTime dt = DateTime.fromMillisecondsSinceEpoch(currentMap.endDate);
      final DateTime justDate = DateTime(dt.year, dt.month, dt.day);
      print(justDate);
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
  }catch(e){
    print("samples error");
    print(e);
    return null;
  }
}

  Future<String> _refresh(){
    setState(() {});
    return Future.value("value doesnt matter ay lmao");
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSamplesMapped(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          var data = snapshot.data;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(

            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext ibContext, int index) {
              DateTime key = data.keys.elementAt(index);
              List<Sample> values = data.values.elementAt(index);
              //return Text("test");
              return Column(
                children: <Widget>[
                  ExpansionTile(
                    title: Text("${key.year}/${key.month}/${key.day}"),
                    children: <Widget>[
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: values.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext ibContext, int index_2) {
                          Sample sample = values[index_2];
                          final color = Colors.lime[200 + 100 * (index_2 % 2)];
                          return selectSampleView(sample.type, sample, color);
                        }
                      )
                    ],
                    initiallyExpanded: true,
                  ) 
                ]
              );
            }
          ));
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
  
}