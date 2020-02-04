import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

final samplesapiInstance = SamplesApi();
final List<String> entries = <String>['A', 'B', 'C'];

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

class _SamplesPageState extends State<SamplesPage> {
  Choice _selectedChoice = choices[0];

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed");
  }
  
  Future<List<Sample>> _fetchSamplesVaried() async {
    try{
      const List<Type> types = [
        Type.distance_,
        Type.elevation_,
        Type.heartRate_,
        Type.sleep_,
        Type.stepCount_,
      ];

      List<Sample> variedSamples = List<Sample>();
      await Future.forEach(types, (type) async{
        var samples = await samplesapiInstance.samplesGet(limit: 2, type: type);
        variedSamples.addAll(samples);
      });

      variedSamples.shuffle();

      var newthing = variedSamples.fold<Map<Type, List<Sample>>>({}, (sampleMap, currentMap) {
        if (sampleMap[currentMap.type] == null) {
          sampleMap[currentMap.type] = [];
        }
        sampleMap[currentMap.type].add(currentMap);
        return sampleMap;
      });
      newthing.forEach((e, v){
          print(e.value + ":" + v.length.toString());
          v.forEach((a){
            print('\t' + a.value.toString());
          });
      });
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

  Future<List<Sample>> _fetchSamples() async {
    try{
      List<Sample> samples = await samplesapiInstance.samplesGet(limit: 200, type: _selectedChoice.type);
      print("Samples retrieved " + samples.length.toString());
      return samples;
    }catch(e){
      print("samples error");
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Samples"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: _select,
            itemBuilder: (BuildContext context){
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title)
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          )
        ],
      ),
      body: FutureBuilder(
        future: _fetchSamplesVaried(),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ibContext, int index) {
                      final color = Colors.lime[200 + 100 * (index % 2)];
                      if(snapshot.data[index].type == Type.sleep_){
                        return SleepSampleView(snapshot.data[index], color);
                      }else{
                        return GenericSampleView(snapshot.data[index], color);
                      }
                    }
                  )
                )
              ]
            );
          }else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _actionButtonAction,
        tooltip: 'Yo',
        child: Icon(Icons.add)
      ),
    );
  }
}

class GenericSampleView extends StatelessWidget {
  GenericSampleView(this.sample, this.color);
  final Sample sample;
  final Color color;
  @override
  Widget build(BuildContext context) {
    var string = sample.type.toString();
    return Container(
      height: 50,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('${sample.type.value} : ${(sample.value is double) ? sample.value.toStringAsFixed(4) : sample.value}'),
              Text("Collected from: ${sample.source_}")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Start date: ${DateTime.fromMillisecondsSinceEpoch(sample.startDate)}"), 
              Text("End date: ${DateTime.fromMillisecondsSinceEpoch(sample.endDate)}")
            ],
          )
        ]
      )
    );
  }
}
class SleepSampleView extends StatelessWidget {
  SleepSampleView(this.sample, this.color);
  final Sample sample;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final Duration duration = Duration(milliseconds: sample.value);
    return Container(
      height: 50,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Slept ${duration.inHours} hrs ${duration.inMinutes - (duration.inHours * 60)} min'),
              Text("Collected from: ${sample.source_}")
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("From: ${DateTime.fromMillisecondsSinceEpoch(sample.startDate)}"), 
              Text("To: ${DateTime.fromMillisecondsSinceEpoch(sample.endDate)}")
            ],
          )
        ]
      )
    );
  }
}

class Choice {
  const Choice({this.title, this.type});

  final String title;
  final Type type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Distance', type: Type.distance_),
  const Choice(title: 'Elevation', type: Type.elevation_),
  const Choice(title: 'Heart rate', type: Type.heartRate_),
  const Choice(title: 'Sleep', type: Type.sleep_),
  const Choice(title: 'Step count', type: Type.stepCount_)
];

