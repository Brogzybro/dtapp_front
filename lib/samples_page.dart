import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:openapi/api.dart' as OA;

import 'sample_views/GenericSampleView.dart';
import 'sample_views/SleepSampleView.dart';
import 'sample_views/_sampleViewSelect.dart';
import 'samples_type_choices.dart';
import 'samples_views/DateGroupedSamplesView.dart';

final samplesapiInstance = SamplesApi();

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

  TypeChoice _selectedChoice = choices[0];

class _SamplesPageState extends State<SamplesPage> {

  void _select(TypeChoice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed");
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
              return choices.map((TypeChoice choice) {
                return PopupMenuItem<TypeChoice>(
                  value: choice,
                  child: Text(choice.title)
                );
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      body: DateGroupedSamplesView(_selectedChoice),
      floatingActionButton: FloatingActionButton(
        onPressed: _actionButtonAction,
        tooltip: 'Yo',
        child: Icon(Icons.add)
      ),
    );
  }
}
