import 'dart:async';

import 'package:dtapp_flutter/export_data_widget.dart';
import 'package:dtapp_flutter/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart' hide Type;
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

UserApi userApi = UserApi();
FitbitApi fitbitApi = FitbitApi();
SamplesApi samplesApi = SamplesApi();
WithingsApi withingsApi = WithingsApi();
PredictionApi predictionApi = PredictionApi();

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _connectWithings() async {
    final idk = await userApi.userTokenPost();
    print(idk.token);

    final url =
        withingsApi.apiClient.basePath + "/withings/auth?token=" + idk.token;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _checkWithingsConnection() async {
    try {
      return await withingsApi.withingsIsauthorizedGet();
    } catch (e) {
      print(e);
    }
    return false;
  }

  void _connectFitbit() async {
    final idk = await userApi.userTokenPost();
    print(idk.token);

    final url =
        fitbitApi.apiClient.basePath + "/fitbit/auth?token=" + idk.token;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _checkFitbitConnection() async {
    try {
      var p = await predictionApi.predictionGet();
      print("----");
      print(p);
      print(p.risk);
      print("--__--");
      return await fitbitApi.fitbitIsauthorizedGet();
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<String> _refresh() {
    setState(() {});
    return Future.value("value doesnt matter ay lmao");
  }

  void _logout() {
    print("yo logging out");
    if (loggedInUser != null) {
      print(loggedInUser.username);
      loggedInUser = null;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: RefreshIndicator(
            child: ListView(children: <Widget>[
              SettingsSection(
                title: Text("Info"),
                children: <Widget>[
                  SettingsItem(
                      leftItem: Text("Username"),
                      rightItem: Text(loggedInUser.username)),
                ],
              ),
              SettingsSection(
                title: Text("Connections"),
                children: <Widget>[
                  SettingsItem(
                      leftItem: Text("Fitbit connection"),
                      rightItem: ConnectionItem(
                        func: _connectFitbit,
                        future: _checkFitbitConnection,
                      )),
                  SettingsItem(
                      leftItem: Text("Withings connection"),
                      rightItem: ConnectionItem(
                        func: _connectWithings,
                        future: _checkWithingsConnection,
                      )),
                ],
              ),
              SettingsSection(
                title: Text("Actions"),
                children: <Widget>[
                  ExportDataWidget(),
                  RaisedButton(
                    child: Text("Log out"),
                    onPressed: _logout,
                  ),
                ],
              )
            ]),
            onRefresh: _refresh));
  }
}

class ConnectionItem extends StatefulWidget {
  ConnectionItem({@required this.func, @required this.future});
  final void Function() func;
  final Future Function() future;
  @override
  _ConnectionItemState createState() => _ConnectionItemState();
}

class _ConnectionItemState extends State<ConnectionItem> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.future(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Container(
                child: Row(
                  children: <Widget>[
                    Text("Connected "),
                    Icon(Icons.check_circle, color: Colors.green)
                  ],
                ),
              );
            } else {
              return RaisedButton(
                  onPressed: widget.func, child: Text("Connect"));
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}

class SettingsSection extends StatelessWidget {
  SettingsSection({@required this.title, @required this.children});
  final Widget title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(margin: EdgeInsets.all(10), child: title),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children)
            ]));
  }
}

class SettingsItem extends StatelessWidget {
  SettingsItem({@required this.leftItem, @required this.rightItem});
  final Widget leftItem;
  final Widget rightItem;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Card(
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[leftItem, rightItem]))));
  }
}
