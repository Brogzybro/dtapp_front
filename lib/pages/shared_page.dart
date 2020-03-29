import 'dart:convert';

import 'package:dtapp_flutter/pages/samples_page.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

SharingApi sharingAPI = SharingApi();

class SharedPage extends StatefulWidget {
  @override
  _SharedPageState createState() => _SharedPageState();
}

class Model {
  String username;
}

Future<String> shareWithUser(username, context) async {
  try {
    final response =
        await sharingAPI.sharedUsersPost(InlineObject()..otherUser = username);
    return response.message;
  } on ApiException catch (e) {
    return jsonDecode(e.message)["error"];
  } catch (e) {
    return e.toString();
  }
}

void goToSamplesForDevicePage(BuildContext context, String otherUser) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SamplesPage(otherUser: otherUser)),
  );
}

class _SharedPageState extends State<SharedPage> {
  final _formKey = GlobalKey<FormState>();
  Model _model = Model();

  Future<List<String>> _usernamesTest() async {
    return Future.delayed(
        Duration(seconds: 1), () => ["test1", "test2", "test3"]);
  }

  Future<List<String>> _getSharedWithYou() async {
    final usernames = await sharingAPI.sharedUsersSharedWithUserGet();
    return usernames;
  }

  Future<List<String>> _getUsersSharedWith() async {
    final usernames = await sharingAPI.sharedUsersOthersSharedWithGet();
    return usernames;
  }

  void _shareWithUser() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final response = await shareWithUser(_model.username, context);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response),
      ));
      print("yo");
      setState(() {});
    }
    print(_model.username);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Shared"),
            actions: <Widget>[],
          ),
          body: ListView(
            children: <Widget>[
              SharedSection(title: "Shared with you", children: <Widget>[
                FutureBuilder(
                  future: _getSharedWithYou(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final usernames = snapshot.data as List<String>;
                      if (usernames.isEmpty)
                        return Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("None",
                                style: TextStyle(fontStyle: FontStyle.italic)));
                      else
                        return Column(
                            children: usernames
                                .map((username) => GestureDetector(
                                    onTap: () => goToSamplesForDevicePage(
                                        context, username),
                                    child: SharedItem(
                                      leftItem: Text(username),
                                      rightItem:
                                          Icon(Icons.keyboard_arrow_right),
                                    )))
                                .toList());
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                )
              ]),
              SharedSection(title: "Users shared with", children: <Widget>[
                FutureBuilder(
                  future: _getUsersSharedWith(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final usernames = snapshot.data as List<String>;
                      if (usernames.isEmpty)
                        return Container(
                            padding: EdgeInsets.only(left: 5),
                            child: Text("None",
                                style: TextStyle(fontStyle: FontStyle.italic)));
                      else
                        return Column(
                            children: usernames
                                .map((username) => SharedItem(
                                      leftItem: Text(username),
                                      rightItem: Text(""),
                                    ))
                                .toList());
                    } else
                      return Center(child: CircularProgressIndicator());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 200,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter username',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                          onSaved: (val) => _model.username = val,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    RaisedButton(
                      child: Text("Share"),
                      onPressed: _shareWithUser,
                    )
                  ],
                )
              ]),
            ],
          ),
        );
      });
    });
  }
}

class SharedSection extends StatelessWidget {
  SharedSection({@required this.title, @required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(child: Text(title, style: TextStyle(fontSize: 18))),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children)
            ]));
  }
}

class SharedItem extends StatelessWidget {
  SharedItem({@required this.leftItem, @required this.rightItem});
  final Widget leftItem;
  final Widget rightItem;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Card(
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[leftItem, rightItem]))));
  }
}
