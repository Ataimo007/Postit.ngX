import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:postit/app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        primaryColorDark: Colors.white,
      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: MyHome(title: "My First App Bar"),
      initialRoute: MyHome.routeName,
      routes: {
        MainSearch.routeName: (context) => MainSearch(),
        MyHome.routeName: (context) => MyHome(title: "Postit.ng"),
        PostAd.routeName: (context) => PostAd(),
        AdDetails.routeName: (context) => AdDetails(),
        UserLogin.routeName: (context) => UserLogin(),
        UserProfile.routeName: (context) => UserProfile(),
        UserRegistration.routeName: (context) => UserRegistration(),
      },
    );
  }
}

class MyHome extends StatefulWidget {
  static const routeName = '/';
  final String title;

  MyHome({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyHomePage(title);
  }
}

class MyHomePage extends State<MyHome> {
  final String title;

  AccountManagement management;
  UserEntity user;

  MyHomePage(this.title);

  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    management = AccountManagement.getInstance();
    management.getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
    _searchFocus.addListener(() {
      _searchFocus.unfocus();
      Navigator.pushNamed(context, MainSearch.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 7, bottom: 7, right: 5, left: 5),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  management.isSignedIn().then((signedIn) {
                    if (signedIn)
                      Navigator.of(context)
                          .pushNamed(UserProfile.routeName)
                          .then((result) {
                        management.getUser().then((user) {
                          setState(() {
                            this.user = user;
                          });
                        });
                      });
                    else
                      Navigator.of(context)
                          .pushNamed(UserLogin.routeName)
                          .then((result) {
                        management.getUser().then((user) {
                          setState(() {
                            this.user = user;
                          });
                        });
                      });
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.green, width: 0.3)),
                  child: _getProfilePic(),
                  width: 40,
                  height: 40,
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Expanded(
                child: TextField(
                  focusNode: _searchFocus,
                  autocorrect: true,
                  cursorColor: Colors.green,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      hasFloatingPlaceholder: false,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(color: Colors.green)),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.green),
                      labelText: 'What Are You Looking For?'),
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Icon(
                Icons.notifications_none,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
      body: AdList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, PostAd.routeName),
        tooltip: 'New Ad',
        icon: Icon(Icons.add),
        label: Text("Post Ad"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    _showCategoryModals(context);
                  }),
            ]),
      ),
    );
  }

  Widget _getProfilePic() {
    return user != null && user.photoLink != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: '${user.photoLink}',
                placeholder: (context, url) =>
                    SvgPicture.asset("assets/user_avatar.svg"),
                errorWidget: (context, url, object) =>
                    SvgPicture.asset("assets/user_avatar.svg"),
                fit: BoxFit.cover,
              ),
            ),
          )
        : SvgPicture.asset("assets/user_avatar.svg");
  }

  _showCategoryModals(context) async {
    final cat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StepperSelection(
          [_getCategories, _getSubCategories],
          [
            (info) {
              CategoryEntity cat = info;
              return cat.categoryName;
            },
            (info) {
              SubCategoryEntity sub = info;
              return sub.categoryName;
            }
          ],
          null,
          ["Category", "Sub Category"],
          layout: [Layout.WRAP],
          provider: [
            (info) {
              CategoryIcon icon =
                  CategoryIcon.getCategory((info as CategoryEntity).id);
              return SvgPicture.asset(
                icon.iconName,
                height: 70,
                width: 70,
              );
            },
          ],
        ),
      ),
    );
  }

  Future<List<CategoryEntity>> _getCategories({dynamic params}) async {
    return await ApiService.getService().getCategories();
  }

  Future<List<SubCategoryEntity>> _getSubCategories({dynamic params}) async {
    CategoryEntity info = params;
    return await ApiService.getService().getSubCategories(info.id);
  }
}
