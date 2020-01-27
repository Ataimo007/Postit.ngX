import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:postit/app.dart';
import 'package:postit/models/login_user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManagement {
  static AccountManagement _management;

  static AccountManagement getInstance() {
    if (_management == null) _management = AccountManagement();
    return _management;
  }

  Future<LoginResponse> signInWithGoogle() async {
    LoginResponse response = await GoogleLogin.signInWithGoogle();
    saveUser(response);
    return response;
  }

  Future<LoginResponse> signInWithFacebook() async {
    LoginResponse response = await FacebookSignUp.signInWithFacebook();
    saveUser(response);
    return response;
  }

  Future<LoginResponse> signInWithPostIt(Map<String, String> login) async {
    dynamic result = await ApiService.getService().login(login);
    var response = LoginResponse.responseInit(result, LoginType.POSTIT);
    saveUser(response);
    return response;
  }

  Future<LoginResponse> updateUsersDetails(
      Map<String, dynamic> user, File image) async {
    LoginUserEntity result =
        await ApiService.getService().updateUser(user, image);
    updateUser(result.result);
    return LoginResponse.update(result);
  }

  void saveUser(LoginResponse response) async {
    UserEntity user = response.user;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("id", user.id);
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("first_name", user.firstName);
    prefs.setString("last_name", user.lastName);
    prefs.setString("user_name", user.userName);
    prefs.setString("gender", user.gender);
    prefs.setString("photo_link", user.photoLink);
    prefs.setString("user_type", user.userType);
    prefs.setString("last_login", user.lastLogin);
    prefs.setString("create_at", user.createdAt);
    prefs.setInt("country_id", user.countryId);
    prefs.setBool("is_login", true);
    prefs.setString("login_type", response.type.toString());
  }

  void updateUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("email", user.email);
    prefs.setString("phone", user.phone);
    prefs.setString("first_name", user.firstName);
    prefs.setString("last_name", user.lastName);
    prefs.setString("user_name", user.userName);
    prefs.setString("gender", user.gender);
    prefs.setString("photo_link", user.photoLink);
    prefs.setString("user_type", user.userType);
    prefs.setInt("country_id", user.countryId);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    var loginType = prefs.getString("login_type");
    var type = LoginType.values
        .firstWhere((LoginType type) => type.toString() == loginType);
    switch (type) {
      case LoginType.FACEBOOK:
        FacebookSignUp.signOutFacebook();
        break;
      case LoginType.GOOGLE:
        GoogleLogin.signOutGoogle();
        break;
      case LoginType.POSTIT:
        // TODO: Handle this case.
        break;
    }

    prefs.remove("id");
    prefs.remove("email");
    prefs.remove("phone");
    prefs.remove("first_name");
    prefs.remove("last_name");
    prefs.remove("user_name");
    prefs.remove("gender");
    prefs.remove("photo_link");
    prefs.remove("user_type");
    prefs.remove("last_login");
    prefs.remove("create_at");
    prefs.remove("country_id");
    prefs.remove("login_type");

    prefs.setBool("is_login", false);
  }

  Future<UserEntity> getUserOrLogin(BuildContext context) async {
    if (await isSignedIn()) {
      return await getUser();
    }
    var user = await Navigator.of(context).pushNamed(UserLogin.routeName);
    return user;
  }

  Future<UserEntity> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (await isSignedIn(prefs: prefs)) {
      UserEntity user = UserEntity();
      user.id = prefs.getInt("id");
      user.email = prefs.getString("email");
      user.phone = prefs.getString("phone");
      user.firstName = prefs.getString("first_name");
      user.lastName = prefs.getString("last_name");
      user.userName = prefs.getString("user_name");
      user.gender = prefs.getString("gender");
      user.photoLink = prefs.getString("photo_link");
      user.userType = prefs.getString("user_type");
      user.lastLogin = prefs.getString("last_login");
      user.createdAt = prefs.getString("create_at");
      user.countryId = prefs.getInt("country_id");
      return user;
    }
    return null;
  }

  Future<bool> isSignedIn({SharedPreferences prefs}) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    bool isSignedIn = prefs.getBool("is_login");
    if (isSignedIn == null) {
      prefs.setBool("is_login", false);
      return false;
    }
    return isSignedIn;
  }
}

enum LoginType { GOOGLE, FACEBOOK, POSTIT }

class LoginResponse {
  final UserEntity user;
  final String msg;
  final bool success;
  final LoginType type;

  LoginResponse(this.user, this.msg, this.success, this.type);

  factory LoginResponse.update(LoginUserEntity user) {
    return LoginResponse(
        user.result,
        user.success
            ? "User profile has been updated sueccessfully"
            : "An error occur while updating",
        user.success,
        null);
  }

  factory LoginResponse.responseInit(dynamic info, LoginType type) {
    if (info is LoginUserEntity) {
      UserEntity user = info.result;
      return LoginResponse(user, "Login Successfully", true, type);
    }
    return LoginResponse(null, "Login Failed", false, type);
  }
}
