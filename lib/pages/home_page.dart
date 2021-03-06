import 'package:dtapp_flutter/pages/analytics_page.dart';
import 'package:dtapp_flutter/pages/samples_page.dart';
import 'package:dtapp_flutter/pages/settings_page.dart';
import 'package:dtapp_flutter/pages/shared_page.dart';
import 'package:flutter/material.dart';

final List<String> entries = <String>['A', 'B', 'C', 'D'];

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    AnalyticsPage(),
    SamplesPage(),
    SharedPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

/*
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("Digital Twin"),
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
      */
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics_rounded), title: Text("Analytics")),
          BottomNavigationBarItem(
              icon: Icon(Icons.art_track), title: Text("Devices")),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared), title: Text("Shared")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColorDark,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class NavWidget extends StatelessWidget {
  NavWidget(this.text, this.widget);

  final Widget widget;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
      title: Text(text),
    ));
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
