import 'package:dtapp_flutter/pages/sample_page.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;

import '../samples/samples_type_choices.dart';

final samplesapiInstance = SamplesApi();

class SamplesPage extends StatefulWidget {
  SamplesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SamplesPageState createState() => _SamplesPageState();
}

class _SamplesPageState extends State<SamplesPage> {
  // TypeChoice _selectedChoice = choices[0];

  /*
  void _select(TypeChoice choice) {
    setState(() {
      _selectedChoice = choice;
    });
  }
  */

  void _actionButtonAction() async {
    print("Useless aciton button pressed yo");
    print(choices);
  }

  void _goToSamplePage(BuildContext context, TypeChoice choice) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SamplePage(choice)),
    );
  }

  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Samples"),
            actions: <Widget>[],
            /*
                bottom: TabBar(
                    isScrollable: true,
                    tabs: <Widget>[Text("test"), Text("test2")],
                  ),
                  */
            /*
        actions: <Widget>[
          Center(child: Text(_selectedChoice.title)),
          PopupMenuButton(
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((TypeChoice choice) {
                return PopupMenuItem<TypeChoice>(
                    value: choice, child: Text(choice.title));
              }).toList();
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
        */
          ),
          body: ListView.builder(
              itemCount: choices.length,
              itemBuilder: (BuildContext context, index) {
                return Card(
                    child: ListTile(
                  title: Text(choices[index].title),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _goToSamplePage(context, choices[index]),
                ));
              }),
          floatingActionButton: FloatingActionButton(
              onPressed: _actionButtonAction,
              tooltip: 'Yo',
              child: Icon(Icons.add)),
        );
      });
    });
  }
}
