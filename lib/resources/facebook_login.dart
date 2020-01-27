import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:postit/app.dart';
import 'package:postit/models/login_user_entity.dart';

class FacebookSignUp {
  final FacebookLogin facebookLogin = FacebookLogin();
  static FacebookSignUp facebook;
  final service = ApiService.getService();

  static FacebookSignUp getInstance() {
    if (facebook == null) facebook = FacebookSignUp();
    return facebook;
  }

  static void signOutFacebook() {
    getInstance().facebookLogin.logOut();
    print("FaceBook Log Out");
  }

  static Future<LoginResponse> signInWithFacebook() async {
    var facebookLoginResult =
        await getInstance().facebookLogin.logIn(['email', 'user_gender']);

    print("Face Book Details");
    print(facebookLoginResult.accessToken);
    print(facebookLoginResult.status);
    print(facebookLoginResult.errorMessage);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        return LoginResponse(
            null, facebookLoginResult.errorMessage, false, LoginType.FACEBOOK);

      case FacebookLoginStatus.cancelledByUser:
        return LoginResponse(
            null, facebookLoginResult.errorMessage, false, LoginType.FACEBOOK);

      case FacebookLoginStatus.loggedIn:
        print("Facebook Login LoggedIn");
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        Map<String, dynamic> profile = json.decode(graphResponse.body);
        print("Facebook Login User $graphResponse");
        print(profile.toString());
        print(profile);

        UserEntity user = await logIntoPostIt(profile);
        return LoginResponse(
            user, "Login Successfully", true, LoginType.FACEBOOK);

      default:
        return LoginResponse(null, "Unknown Error", false, LoginType.FACEBOOK);
    }
  }

  static Future<UserEntity> logIntoPostIt(Map<String, dynamic> profile) async {
    Map<String, dynamic> params = {
      "login_type": "social",
      "email": profile['email'],
      "first_name": profile['first_name'],
      "last_name": profile['last_name'],
      "gender": profile['gender'],
      "name": profile['name'],
      "photo": profile['picture']['data']['url']
    };
    print("params are $params");
    return (await getInstance().service.login(params) as LoginUserEntity)
        .result;
  }

  static int getCountryId(String country) {
    return 78;
  }

  // other facebook graph api calls
//        https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult.accessToken.token}
//        https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}

}
