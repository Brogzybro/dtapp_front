import 'package:dtapp_flutter/login_page.dart';
import 'package:dtapp_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'signup_page.dart';

var sampleapi_instance = SamplesApi();
final List<String> entries = <String>['A', 'B', 'C'];

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _select(Choice choice) {
    setState(() {
      switch (choice.action) {
        case 'logout':
          print("yo logging out");
          if(loggedInUser != null){
            print(loggedInUser.username);
            loggedInUser = null;
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          break;
        default:
      }
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed");
    print("Trying to get samples...");
    try{
      var samples = await sampleapi_instance.samplesGet(limit: 10);
      print("Samples retrieved " + samples.length.toString());
      samples.take(10).forEach((sample){
        print(DateTime.fromMillisecondsSinceEpoch(sample.startDate));
      });
      //print(samples);
    }catch(e){
      print("samples error");
      print(e);
    }
  }

  Future<List<Sample>> _fetchSamples() async {
    try{
      var samples = await sampleapi_instance.samplesGet(limit: 20, type: Type.sleep_);
      print("Samples retrieved " + samples.length.toString());
      return samples;
    }catch(e){
      print("samples error");
      print(e);
      return null;
    }
  }
 // TODO do filtering stuff
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
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
                                Text('${snapshot.data[index].type} : ${snapshot.data[index].value}'),
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
          return CircularProgressIndicator();
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
  const Choice({this.title, this.action});

  final String title;
  final String action;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Log out', action: 'logout')
];