import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:url_launcher/url_launcher.dart';

FitbitApi fitbitApi = FitbitApi();
class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SettingsPageState();
  
}

class _SettingsPageState extends State<SettingsPage> {


  void _connectFitbit() async {
    final idk = await fitbitApi.userTokenPost();
    print(idk.token);


    final url = fitbitApi.apiClient.basePath + "/fitbit/auth?token=" + idk.token;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<bool> _checkFitbitConnection() async {
    try {
      return await fitbitApi.fitbitIsauthorizedGet();
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 60,
            child: Card(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Fitbit connection"),
                    FutureBuilder(
                      future: _checkFitbitConnection(),
                      builder: (BuildContext context, snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data){
                            return Container(
                              child: Row(
                                children: <Widget>[
                                  Text("Connected "),
                                  Icon(Icons.check_circle, color: Colors.green)
                                ],
                              ),
                            );
                          }else{
                            return RaisedButton(
                              onPressed: _connectFitbit,
                              child: Text("Connect")
                            );
                          }
                        }else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }
                    ),
                    
                  ],
                ),
              )
              
            )
          )
        ]
      )
    );
  }
  
}