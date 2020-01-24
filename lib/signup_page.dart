import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'login_page.dart';

var api_instance = UserApi();

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const _init_counter = 0;
  static const _myTexts = [
    "Hi press me", 
    "Yo wtf why you press me. And more text just to test asd", 
    "Stop",
    "Stop pressing", 
    "Stop pressing me", 
    "Wtf dude"
  ];
  int _counter = _init_counter;
  String _myText = _myTexts[_init_counter];

  void _signupAction() async{
    print("yo");
    setState(() {
        // This call to setState tells the Flutter framework that something has
        // changed in this State, which causes it to rerun the build method below
        // so that the display can reflect the updated values. If we changed
        // _counter without calling setState(), then the build method would not be
        // called again, and so nothing would appear to happen.
        _counter++;
        _myText = _myTexts[_counter % _myTexts.length];

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up to Digital Twin")
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
                        "Sign up",
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
                        child: Text('Sign up')
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
                            MaterialPageRoute(builder: (context) => LoginPage(title: "test")),
                          );
                          print("yo");
                        },
                        child: Text('Log in'),
                        color: Colors.orangeAccent
                      ),
                  ],
                ),
              ),
            )
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _signupAction,
          tooltip: 'Yo',
          child: Icon(Icons.add)
        ),
    );
  }
}