import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

import 'login_page.dart';

var userapiInstance = UserApi();
var fitbitapiInstance = FitbitApi();

class SignupPage extends StatefulWidget {
  SignupPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  Model _model = new Model();

  void _actionButtonAction() {
    print("Useless aciton button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up to Digital Twin")),
      body: Builder(builder: (BuildContext context) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Attempting sign up..."),
                            duration: Duration(minutes: 5)));

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          attemptSignup(_model).then((text) {
                            //     : "User creation failed. Username probably taken.";
                            print(text);
                            Scaffold.of(context).hideCurrentSnackBar();
                            Scaffold.of(context)
                                .showSnackBar(SnackBar(content: Text("User creation failed. " + text)));
                          });
                        }
                        print("yo");
                      },
                      child: Text('Sign up')),
                  RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        //if (_formKey.currentState.validate()) {
                        // Process data.
                        //}'
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage(title: "test")),
                        );
                        print("yo");
                      },
                      child: Text('Go to log in'),
                      color: Colors.orangeAccent),
                ],
              ),
            ),
          )
        ]);
      }),
    );
  }
}

Future<String> attemptSignup(Model model) async {
  print("Signing up...");
  var user = new User();
  user.username = model.username;
  user.password = model.password;
  try {
    var postReq = await userapiInstance.userPost(user);
    print("User created");
    print(postReq);
    return "User created!";
  } on ApiException catch (e) {
    print(e);
    print(e.code);
    print('ayyy');
    switch (e.code) {
      case 422:
        return "Username already taken.";
        break;
      case 400:
        return "Make sure password is 8 characters or more";
        break;
      default:
        return "";
    }
  } catch (e) {
    print(e);
    return e.toString();
  }
}
