import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

import 'samples/samples_type_choices.dart';
import 'samples/samples_views/DateGroupedSamplesView.dart';

final samplesapiInstance = SamplesApi();

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

// TODO: Load more entries when scrolling down
class _SamplesPageState extends State<SamplesPage> {
  TypeChoice _selectedChoice = choices[0];

  void _select(TypeChoice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed yo");
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
