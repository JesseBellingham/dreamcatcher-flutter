import 'dart:convert';

import 'package:dreamcatcher/login.dart';
import 'package:dreamcatcher/models/new_dream.dart';
import 'package:dreamcatcher/models/public_dreams.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool isLoggedIn;
  dynamic fbUser;

  var facebookLogin = FacebookLogin();
  @override
  void initState() {
    super.initState();
    isLoggedIn = false;
    dynamic user;
    facebookLogin.isLoggedIn.then((val) async {
      if (val) {
        var token = await facebookLogin.currentAccessToken.then((val) => val.token);
        var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${token}');

        user = json.decode(graphResponse.body);
      }
      setState(() {
        isLoggedIn = val;
        fbUser = user;
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
            PublicDreams(changeLoginStatus: _changeLoginStatus) :
            LoginPage(
              changeLoginStatus: _changeLoginStatus,
              fbUser: _fbUser),
        '/NewDream': (context) => NewDream()
      },
    );
  }

  _changeLoginStatus(val) {
    setState(() {
      isLoggedIn = val ?? false;
    });
  }

  _fbUser(user) {
    setState(() {
      fbUser = user;
    });
  }
}