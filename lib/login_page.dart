import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _incrementCounter() async{

    var user = new User();
    user.username = "darttestuser22";
    user.password = "darttestuserpass213";
    try{
      var postReq = await api_instance.userPost(user);
      print("User created");
      print(postReq);
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to your Digital Twin'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                      Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                          ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your username',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          //if (_formKey.currentState.validate()) {
                            // Process data.
                          //}'
                          print("yo");
                        },
                        child: Text('Log in')
                      ),
                      RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          //if (_formKey.currentState.validate()) {
                            // Process data.
                          //}'
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignupPage()),
                          );
                          print("yo");
                        },
                        child: Text('Sign up'),
                        color: Colors.orangeAccent
                      ),
                  ],
                ),
              ),
            )
          ]
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
