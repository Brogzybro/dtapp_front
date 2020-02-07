import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
  
}

class _SettingsPageState extends State<SettingsPage> {


  void _connectFitbit() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
              onPressed: _connectFitbit,
              child: Text("Connect fitbit")
            )
          ),
        ]
      )
    );
  }
  
}