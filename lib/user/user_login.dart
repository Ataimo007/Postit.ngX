import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:postit/app.dart';

class UserLogin extends StatefulWidget {
  static const String routeName = 'user/login';

  UserLogin({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserLogin();
  }
}

class _UserLogin extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> login = {};
  final FocusNode _passwordFocus = FocusNode();

  var _opacity = 0.0;

  var _obscured = true;

  var _hasFocus = false;

  AccountManagement management;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget content = getContent();
    return content;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _opacity = 0.5;
        }));
    _passwordFocus.addListener(() {
      setState(() {
        _hasFocus = _passwordFocus.hasFocus;
      });
    });
    management = AccountManagement.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocus.dispose();
  }

  Widget getContent() {
    return Stack(children: <Widget>[
      Container(
        color: Colors.white,
        constraints: BoxConstraints.expand(),
        child: Image.asset(
          "assets/login_background3.jpg",
          fit: BoxFit.cover,
        ),
      ),
      Positioned.fill(
          child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
        child: Container(
          color: Colors.white.withOpacity(0),
        ),
      )),
      Positioned.fill(
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _opacity,
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
      Theme(
        data: ThemeData(
          hintColor: Colors.white,
          primaryColor: Colors.green,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ListView(children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    child: Image.asset("assets/logo2.png"),
                    width: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset("assets/user_avatar.svg"),
                    ),
                    width: 100,
                    height: 100,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  autocorrect: true,
                  cursorColor: Colors.green,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please you need to enter your email";
                    return null;
                  },
                  onSaved: (value) {
                    login['email'] = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Address',
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  focusNode: _passwordFocus,
                  obscureText: _obscured,
                  cursorColor: Colors.green,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please you need to enter your password";
                    return null;
                  },
                  onSaved: (value) {
                    login['password'] = value;
                  },
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscured = !_obscured;
                          });
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: _hasFocus ? Colors.green : Colors.white,
                        )),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        management.signInWithGoogle().then((response) {
                          showToast(response.msg);
                          if (response.success)
                            Navigator.of(context).pop(response.user);
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        elevation: 10,
                        child: SvgPicture.asset(
                          'assets/google_icon.svg',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        management.signInWithFacebook().then((response) {
                          showToast(response.msg);
                          if (response.success)
                            Navigator.of(context).pop(response.user);
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        elevation: 10,
                        child: SvgPicture.asset(
                          'assets/facebook_icon.svg',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    Spacer(),
                    RaisedButton(
                      elevation: 10,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          login['login_type'] = "postit";
                          management.signInWithPostIt(login).then((response) {
                            showToast(response.msg);
                            if (response.success)
                              Navigator.of(context).pop(response);
                          });
                        }
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, top: 15, bottom: 15),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't Hava A Profile Yet "),
                      FlatButton(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(UserRegistration.routeName);
                        },
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    ]);
  }
}
