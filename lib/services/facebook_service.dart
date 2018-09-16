import 'dart:async';
import 'dart:convert';

import 'package:dreamcatcher/models/facebook_user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

var _facebookLogin = FacebookLogin();

class FacebookService {
  Future<FacebookUser> getFacebookUser() async {
    var tokenResult = await _facebookLogin.currentAccessToken.then((val) => val);
    if (tokenResult != null) {
      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${tokenResult.token}');
      var userData = json.decode(graphResponse.body);
      return map(userData);
    }
    return null;
  }

  FacebookUser map(dynamic userData) {
    return FacebookUser.withAll(userData["id"], userData["name"], userData["first_name"], userData["last_name"], userData["picture"]);
  }
}