import 'package:dtapp_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'signup_page.dart';
import 'home_page.dart';

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

class Model {
  String username;
  String password;
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  
  Model _model = Model();

  void _incrementCounter() async{

/*
    var user = new User();
    user.username = "darttestuser22";
    user.password = "darttestuserpass213";
    try{
      var postReq = await userapi_instance.userPost(user);
      print("User created");
      print(postReq);
    } catch(e){
      print(e);
    }
    */
    try {
      await userapi_instance.rootGet();
      print("Success token at incr");
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to your Digital Twin'),
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
                                content: Text("Attempting log in..."),
                                duration: Duration(minutes: 5)
                              )
                            );
                            
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              attemptLogin(_model).then((success){
                                var text = (success) ? 
                                  "Logged in successfully!" : "Login failed. Check username/password.";
                                print(text);
                                Scaffold.of(context).hideCurrentSnackBar();
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(text)
                                  )
                                );
                                if(success){
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomePage(title: "test")),
                                  );     
                                }
                              });                       
                            }
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
                          child: Text('Go to Sign up'),
                          color: Colors.orangeAccent
                        )
                    ]
                  )
                )
              )
            ]
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<bool> attemptLogin(Model model) async{
  print("Attempting login...");
  HttpBasicAuth bauth = userapi_instance.apiClient.getAuthentication("basicAuth");
  bauth.username = model.username;
  bauth.password = model.password;
  try {
    await userapi_instance.rootGet();
    print("Success");
    User user = new User();
    user.username = model.username;
    user.password = model.password;
    loggedInUser = user;
    return true;
  } catch (e){
    print(e);
    return false;
  }
}