import 'package:dreamcatcher/login.dart';
import 'package:dreamcatcher/models/new_dream.dart';
import 'package:dreamcatcher/models/public_dreams.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Catcher',
      initialRoute: '/',
      routes: {
        // When we navigate to the "/" route, build the FirstScreen Widget
        // '/': (context) => PublicDreams(),
        '/': (context) => LoginPage(),
        '/NewDream': (context) => NewDream()
      },
    );
  }
}