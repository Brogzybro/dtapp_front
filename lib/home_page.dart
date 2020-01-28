import 'package:dtapp_flutter/login_page.dart';
import 'package:dtapp_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'signup_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
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

  void _actionButtonAction(){
    print("Useless aciton button pressed");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      body: Builder(
        builder: (BuildContext context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Yo"),
                Text(_selectedChoice.title)
              ]
            );
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