import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:postit/app.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = 'user/profile';

  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserProfile> {
  final Function f = () {};
  List<List<AdBriefEntity>> ads = [];

  UserEntity user;
  static final List<ProductState> _tabs = ProductState.values;

  @override
  initState() {
    super.initState();
    AccountManagement.getInstance().getUser().then((user) {
      setState(() {
        this.user = user;
      });
    });
    _tabs.forEach((tab) {
      ads.add([]);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      child: Scaffold(
        body: _getContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, PostAd.routeName).then((value) {
            ads.forEach((ads) => ads.clear());
            setState(() {});
          }),
          tooltip: 'New Ad',
          child: Icon(Icons.add),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
      length: _tabs.length,
    );
  }

  _getAppBar(bool innerBoxIsScrolled) {
    return SliverAppBar(
      actions: <Widget>[
        Icon(
          Icons.notifications,
          color: Colors.black,
        ),
        PopupMenuButton<Function>(
          onSelected: (action) => action(),
          itemBuilder: (context) => <PopupMenuEntry<Function>>[
            PopupMenuItem<Function>(
              child: Text("Edit Profile"),
              value: () {
                Navigator.pushNamed(context, UserRegistration.routeName,
                        arguments: user.id)
                    .then((value) {
                  AccountManagement.getInstance().getUser().then((user) {
                    setState(() {
                      this.user = user;
                    });
                  });
                });
              },
            ),
            PopupMenuItem<Function>(
              child: Text("Logout"),
              value: () {
                AccountManagement.getInstance().signOut().then((_) {
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        )
      ],
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.green),
      actionsIconTheme: IconThemeData(color: Colors.green),
      expandedHeight: 300,
      forceElevated: innerBoxIsScrolled,
      textTheme: TextTheme(title: TextStyle(color: Colors.green)),
      bottom: TabBar(
          isScrollable: true,
          labelColor: Colors.green,
          tabs: _tabs
              .map((state) => Tab(
                    text: state.name.toUpperCase(),
                  ))
              .toList()),
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _getProfilePic(),
                ),
                width: 150,
                height: 150,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.getFullName(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone_android,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text(user.phone)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(user.email),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _getProfilePic() {
    return user.photoLink == null || user.photoLink.isEmpty
        ? SvgPicture.asset("assets/user_avatar.svg")
        : ClipRRect(
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
          );
  }

  _getContent() {
    return user == null
        ? null
        : DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    child: _getAppBar(innerBoxIsScrolled),
                  ),
                ];
              },
              body: TabBarView(
                  // These are the contents of the tab views, below the tabs.
                  children: _tabs
                      .asMap()
                      .map((index, state) =>
                          MapEntry(index, _getTabViews(state, index)))
                      .values
                      .toList(growable: false)),
            ),
          );
  }

  Widget _getTabViews(ProductState state, int index) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            key: PageStorageKey<String>(state.name),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              ProductList(user, state, ads[index]),
            ],
          );
        },
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  final UserEntity user;
  final ProductState state;
  final List<AdBriefEntity> ads;

  ProductList(this.user, this.state, this.ads, {Key key}) : super(key: key);

  @override
  _ProductListState createState() {
    return _ProductListState(ads);
  }
}

class _ProductListState extends State<ProductList> {
  final List<AdBriefEntity> ads;

  static const pageSize = 20;
  static const countThres = 10;
  bool loading = false;

  _ProductListState(this.ads);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _load({bool isClear = false}) {
    getAds().then((ads) {
      if (ads.isNotEmpty || isClear) {
        setState(() {
          this.ads.addAll(ads);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (ads.isEmpty) _load();

    if (ads.isEmpty)
      return SliverPadding(
        padding: const EdgeInsets.all(8.0),
      );
    else
      return SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              // This builder is called for each child.
              // In this example, we just number each list item.
              return getAd(index);
            },
          ),
        ),
      );
  }

  _refresh() {
    ads.clear();
    _load(isClear: true);
  }

  getAd(index) {
    if (ads.length - index <= 10)
      getAds().then((ads) {
        this.ads.addAll(ads);
      });
    if (index < ads.length)
      switch (widget.state.state) {
        case 0:
        case 1:
          return AdWidget(
            ads[index],
            refresh: _refresh,
            isUser: true,
          );

        case 2:
        case 3:
          return AdWidget(
            ads[index],
            refresh: _refresh,
            isInActive: true,
            isUser: true,
          );
      }

    if (index == ads.length) return SizedBox(height: 100);
    return null;
  }

  Future<List<AdBriefEntity>> getAds() async {
    if (!loading) {
      loading = true;
      List<AdBriefEntity> ads;
      if (widget.state.state == 4)
        ads = [];
      else
        ads = await ApiService.getService().getUserAdsByStates(
            "${widget.user.id},${widget.state.state},${this.ads.length},$pageSize");
      loading = false;
      return ads;
    } else
      return [];
  }
}

class ProductState {
  final String name;
  final int state;

  static final List<ProductState> values = [
    ProductState("published", 1),
    ProductState("pending", 0),
    ProductState("favorite", 4),
    ProductState("blocked", 2),
    ProductState("closed", 3),
  ];

  ProductState(this.name, this.state);
}
