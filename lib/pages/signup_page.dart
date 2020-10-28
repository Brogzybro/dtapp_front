import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'package:age/age.dart';

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
  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();

  void _actionButtonAction() {
    print("Useless aciton button pressed");
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(1900, 1),
        lastDate: today);
    if (picked != null && picked != today)
      setState(() {
        _model.birthdate = picked;
        selectedDate = picked;

        // Local age variables for testing
        int age1 = (today.difference(selectedDate).inDays / 365.25).floor();

        AgeDuration age2 =
            Age.dateDifference(fromDate: selectedDate, toDate: today);

        print("Using only DateTime: You are $age1 years old");
        print("Using age package: You are ${age2.years} years old");
        print("picked: ${picked.millisecondsSinceEpoch}");
      });
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text("${selectedDate.toLocal()}".split(' ')[0]),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select your birthday'),
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
                                .showSnackBar(SnackBar(content: Text(text)));
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
  user.birthDate = model.birthdate.millisecondsSinceEpoch;
  try {
    var postReq = await userapiInstance.userPost(user);
    print("User created");
    print(postReq);
    return "User created!";
  } on ApiException catch (e) {
    print(e);
    print(e.code);
    print('ayyy');
    String text = "User creation failed. ";
    switch (e.code) {
      case 422:
        text += "Username already taken.";
        break;
      case 400:
        text += "Make sure password is 8 characters or more";
        break;
      default:
        break;
    }
    return text;
  } catch (e) {
    print(e);
    return e.toString();
  }
}
