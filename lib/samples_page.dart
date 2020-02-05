import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

final samplesapiInstance = SamplesApi();
final List<String> entries = <String>['A', 'B', 'C'];

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

  Choice _selectedChoice = choices[0];

class _SamplesPageState extends State<SamplesPage> {

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed");
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
          Center(child:Text(_selectedChoice.title)),
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
          ),
        ],
      ),
      body: DateGroupedSamplesView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _actionButtonAction,
        tooltip: 'Yo',
        child: Icon(Icons.add)
      ),
    );
  }
}

Future<Map<DateTime, List<Sample>>> fetchSamplesMapped() async {
  try{
    var samples = await samplesapiInstance.samplesGet(limit: 200, type: _selectedChoice.type);
    
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

Future<Map<DateTime, List<Sample>>> fetchSamplesVariedMapped() async {
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
    
    var mapped = variedSamples.fold<Map<DateTime, List<Sample>>>({}, (sampleMap, currentMap) {
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

    
    print("Samples retrieved " + variedSamples.length.toString());
    return mapped;
  }catch(e){
    print("samples error");
    print(e);
    return null;
  }
}

Future<List<Sample>> fetchSamplesVaried() async {
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

Widget selectSampleView(OA.Type type, Sample sample, Color color) {
  switch (type) {
    case OA.Type.sleep_:
      return SleepSampleView(sample, color);
      break;
    default:
      return GenericSampleView(sample, color);
  }
}

class DateGroupedSamplesView extends StatelessWidget {
  DateGroupedSamplesView();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchSamplesMapped(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasData){
          var data = snapshot.data;
          return ListView.builder(
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
          );
        }else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }
  
}

class GenericSamplesView extends StatelessWidget {
  GenericSamplesView();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchSamplesVaried(),
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
  final OA.Type type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Distance', type: OA.Type.distance_),
  const Choice(title: 'Elevation', type: OA.Type.elevation_),
  const Choice(title: 'Heart rate', type: OA.Type.heartRate_),
  const Choice(title: 'Sleep', type: OA.Type.sleep_),
  const Choice(title: 'Step count', type: OA.Type.stepCount_)
];

