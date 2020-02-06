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

enum Department {
  treasury,
  state
}

class _SamplesPageState extends State<SamplesPage> {
  TypeChoice _selectedChoice = choices[0];

  Future<void> _openDialog() async {
    switch (await showDialog<Department>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select assignment'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, Department.treasury); },
              child: const Text('Treasury department'),
            ),
            SimpleDialogOption(
              onPressed: () { Navigator.pop(context, Department.state); },
              child: const Text('State department'),
            ),
          ],
        );
      }
    )) {
      case Department.treasury:
        // Let's go.
        // ...
      break;
      case Department.state:
        // ...
      break;
    }
  }

  void _select(TypeChoice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }

  void _actionButtonAction() async{
    print("Useless aciton button pressed yo");
    _openDialog();
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
