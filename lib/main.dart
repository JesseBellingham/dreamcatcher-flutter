import 'package:dreamcatcher/login.dart';
import 'package:dreamcatcher/models/new_dream.dart';
import 'package:dreamcatcher/models/public_dreams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _MyAppState();
}
  class _MyAppState extends State<MyApp> {
    bool isLoggedIn;

    var facebookLogin = FacebookLogin();
    @override
    void initState() {
      super.initState();
      facebookLogin.isLoggedIn.then((val) {
        setState(() {
          isLoggedIn = val;
        });
      });
    }
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Dream Catcher',
        initialRoute: '/',
        routes: {
          '/': (context) =>
            isLoggedIn ?
              PublicDreams() :
              LoginPage(changeLoginStatus: _changeLoginStatus),
          '/NewDream': (context) => NewDream()
        },
      );
    }

    _changeLoginStatus(val) {
      setState(() {
        isLoggedIn = val ?? false;
      });
    }
  }