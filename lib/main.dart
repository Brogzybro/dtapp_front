import 'package:dtapp_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openapi/api.dart';

import 'pages/login_page.dart';

User loggedInUser;

Future main() async {
  await DotEnv().load('.env');
  String u = DotEnv().env['DEV_USERNAME'];
  String p = DotEnv().env['DEV_PASSWORD'];
  if (u != null && p != null) {
    await attemptLogin(Model()
      ..username = u
      ..password = p);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DTApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (loggedInUser == null) ? LoginPage() : HomePage(),
    );
  }
}
