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

  Future<List<Sample>> _fetchSamples() async {
    try{
      var samples = await samplesapiInstance.samplesGet(limit: 200, type: _selectedChoice.type);
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
        future: _fetchSamples(),
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
                      return Container(
                        height: 50,
                        color: Colors.amber[200 + 100 * (index % 2)],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text('${snapshot.data[index].type} : ${(snapshot.data[index].value is double) ? snapshot.data[index].value.toStringAsFixed(4) : snapshot.data[index].value}'),
                                Text("Collected from: ${snapshot.data[index].source_}")
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text("Start date: ${DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].startDate)}"), 
                                Text("End date: ${DateTime.fromMillisecondsSinceEpoch(snapshot.data[index].endDate)}")
                              ],
                            )
                          ]
                        )
                      );
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

