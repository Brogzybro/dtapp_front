import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'login_page.dart';

var userapi_instance = UserApi();
var fitbitapi_instance = FitbitApi();

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  Model _model = new Model();
  
  void _actionButtonAction(){
    print("Useless aciton button pressed");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up to Digital Twin")
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Form(
                    key: _formKey,
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
                            onSaved: (val) => _model.username = val,
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
                            onSaved: (val) => _model.password = val,
                            obscureText: true,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Attempting sign up..."),
                                  duration: Duration(minutes: 5)
                                )
                              );

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                attemptSignup(_model).then((success){
                                  var text = (success) ? 
                                    "User created!" : "User creation failed. Username probably taken.";
                                  print(text);
                                  Scaffold.of(context).hideCurrentSnackBar();
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(text)
                                    )
                                  );

                                });
                              }
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
                            child: Text('Go to log in'),
                            color: Colors.orangeAccent
                          ),
                      ],
                    ),
                  ),
                )
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

Future<bool> attemptSignup(Model model) async{
  print("Signing up...");
  var user = new User();
  user.username = model.username;
  user.password = model.password;
  try{
    var postReq = await userapi_instance.userPost(user);
    print("User created");
    print(postReq);
    return true;
  } catch(e){
    print(e);
    return false;
  }
}