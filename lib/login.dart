import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
    this.changeLoginStatus,
    this.fbUser
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
  final ValueChanged<void> changeLoginStatus;
  final ValueChanged<void> fbUser;
}

class _LoginPageState extends State<LoginPage> {
  bool isLoggedIn;
  dynamic profileData;
  var facebookLogin = FacebookLogin();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
    widget.changeLoginStatus(isLoggedIn);
    widget.fbUser(profileData);
  }

  @override
  initState() {
    super.initState();
    this.isLoggedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Facebook Login"),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(
          //       Icons.exit_to_app,
          //       color: Colors.white,
          //     ),
          //     onPressed: () => facebookLogin.isLoggedIn
          //         .then((isLoggedIn) => isLoggedIn ? _logout() : {}),
          //   ),
          // ],
        ),
        body: Container(
          child: Center(
            child: isLoggedIn
                ? Navigator.of(context).pushNamed('/')//_displayUserData(profileData)
                : _displayLoginButton(),
          ),
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        FirebaseAuth.instance.signInWithFacebook(accessToken: facebookLoginResult.accessToken.token);
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult
                .accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());

        onLoginStatusChanged(true, profileData: profile);
        break;
    }
  }

  _displayUserData(profileData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 200.0,
          width: 200.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        SizedBox(height: 28.0),
        Text(
          "Logged in as: ${profileData['name']}",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  _displayLoginButton() {
    return RaisedButton(
      child: Text("Login with Facebook"),
      onPressed: () => initiateFacebookLogin(),
    );
  }

  // _logout() async {
  //   await facebookLogin.logOut();
  //   onLoginStatusChanged(false);
  //   print("Logged out");
  // }
}
