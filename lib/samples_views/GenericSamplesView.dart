import 'package:dtapp_flutter/sample_views/_sampleViewSelect.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

final samplesapiInstance = SamplesApi();

class GenericSamplesView extends StatelessWidget {
  GenericSamplesView();

  Future<List<Sample>> _fetchSamplesVaried() async {
    try{
      const List<OA.Type> types = [
        OA.Type.distance_,
        OA.Type.elevation_,
        OA.Type.heartRate_,
        OA.Type.sleep_,
        OA.Type.stepCount_,
      ];

      List<Sample> variedSamples = List<Sample>();
      await Future.forEach(types, (type) async{
        var samples = await samplesapiInstance.samplesGet(limit: 4, type: type);
        variedSamples.addAll(samples);
      });

      variedSamples.shuffle();
      
      /*
      var map = Map.fromIterable(variedSamples, key: (e) => e.type, value: (e) => e);

      map.forEach((e, v){
          print(e.toString() + ":" + v.toString());
      });
      */

      
      print("Samples retrieved " + variedSamples.length.toString());
      return variedSamples;
    }catch(e){
      print("samples error");
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSamplesVaried(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          var data = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext ibContext, int index) {
              final color = Colors.lime[200 + 100 * (index % 2)];
              return selectSampleView(data[index].type, data[index], color);
            }
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

}