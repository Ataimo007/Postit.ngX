import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:postit/app.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetails extends StatefulWidget {
  static const routeName = 'ad/details';

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdDetails();
  }
}

class _AdDetails extends State<AdDetails> {
  AdBriefEntity brief;
  AdEntity ad;

  final List<AdBriefEntity> ads = [];

  static const pageSize = 20;
  static const countThres = 10;
  bool loading = false;
  CategoryIcon icon;

  @override
  void initState() {
    super.initState();
  }

  _init(BuildContext context) {
    brief = ModalRoute.of(context).settings.arguments;

    if (ad == null) {
      getDetails().then((ad) {
        icon = CategoryIcon.getCategory(ad.ad.categoryId);
        setState(() {
          this.ad = ad;
        });
        getAds().then((ads) {
          setState(() {
            this.ads.addAll(ads);
          });
        });
      });
    }
  }

  _getContent(BuildContext context) {
    return ad != null ? getContent(context) : null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _getContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => launch("tel:${ad.ad.sellerPhone}"),
        tooltip: 'New Ad',
        child: Icon(Icons.call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {}),
            ]),
        notchMargin: 4.0,
      ),
    );
  }

  getAppBar() {
    return SliverAppBar(
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.green),
      actionsIconTheme: IconThemeData(color: Colors.green),
      expandedHeight: 300,
      textTheme: TextTheme(
          title: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      )),
      titleSpacing: 0,
      title: Container(
        child: Text(
          ad.ad.title,
          maxLines: 2,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
            child: Stack(
          children: <Widget>[
            CarouselSlider(
              items: getImages(),
              height: 250,
              aspectRatio: 16 / 4,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              pauseAutoPlayOnTouch: Duration(seconds: 10),
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.5),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ad.ad.getLocation(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  ad.ad.getFullTime(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        ad.ad.getFullPrice(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
            Positioned(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.photo_camera,
                        color: Colors.black54,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${ad.medias.length.toString()} Images",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                constraints: BoxConstraints.expand(height: 50),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.5),
                      ]),
                ),
              ),
              top: 0,
              left: 0,
              right: 0,
            )
          ],
        )),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  getContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        getAppBar(),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => getList(context, index)),
        )
      ],
    );
  }

  getList(BuildContext context, int index) {
    switch (index) {
      case 0:
        return getSpecs();

      case 1:
        return getDescription();

      case 2:
        return getUser();

      default:
        return getSimilar(index);
    }
  }

  getRow(name, value) {
    return TableRow(
      children: <Widget>[
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
          verticalAlignment: TableCellVerticalAlignment.middle,
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 10),
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
          verticalAlignment: TableCellVerticalAlignment.middle,
        )
      ],
    );
  }

  getRowIcon(icon, color, value) {
    return TableRow(
      children: <Widget>[
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          verticalAlignment: TableCellVerticalAlignment.middle,
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
          verticalAlignment: TableCellVerticalAlignment.middle,
        )
      ],
    );
  }

  getSpecTable() {
    var specs = <TableRow>[];
    if (ad.ad.brandName != null) specs.add(getRow("Make", ad.ad.brandName));
    if (ad.ad.modelName != null) specs.add(getRow("Model", ad.ad.modelName));
    if (ad.ad.transmission != null)
      specs.add(getRow("Transmission", ad.ad.transmission));
    if (ad.ad.bodyStyleName != null)
      specs.add(getRow("Body Style", ad.ad.bodyStyleName));
    if (ad.ad.adCondition != null)
      specs.add(getRow("Condition", ad.ad.adCondition));
    return specs;
  }

  getSpecs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15.0, bottom: 30),
          child: Column(
            children: <Widget>[
              Align(
                child: Text(
                  "Specification",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                alignment: Alignment.centerLeft,
              ),
              Divider(color: Colors.green),
              Table(
                columnWidths: {0: IntrinsicColumnWidth()},
                children: getSpecTable(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUser() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15.0, bottom: 30),
          child: Column(
            children: <Widget>[
              Align(
                child: Text(
                  "Seller's Information",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                alignment: Alignment.centerLeft,
              ),
              Divider(color: Colors.green),
              Table(
                columnWidths: {0: FixedColumnWidth(70)},
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.person,
                        size: 70,
                      ),
                    ),
                    Table(
                      columnWidths: {0: IntrinsicColumnWidth()},
                      children: <TableRow>[
                        TableRow(children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              ad.ad.sellerName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]),
                        TableRow(children: <Widget>[
                          Table(
                            columnWidths: {0: IntrinsicColumnWidth()},
                            children: <TableRow>[
                              getRowIcon(Icons.location_city, Colors.black,
                                  ad.ad.address),
                              getRowIcon(Icons.location_on, Colors.red,
                                  "${ad.ad.cityName}, ${ad.ad.stateName}, ${ad.ad.countryName}"),
                              getRowIcon(
                                  Icons.email, Colors.green, ad.ad.sellerEmail),
                            ],
                          )
                        ])
                      ],
                    )
                  ])
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15.0, bottom: 30),
          child: Column(
            children: <Widget>[
              Align(
                child: Text(
                  "Description",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                alignment: Alignment.centerLeft,
              ),
              Divider(color: Colors.green),
              Text(
                ad.ad.description,
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  getImages() {
    if (ad.medias.length == 0)
      return <Widget>[
        SvgPicture.asset(
          icon.iconName,
        )
      ];
    return ad.medias.map((image) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: 100,
          constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 100,
              minWidth: double.infinity,
              maxWidth: double.infinity),
          child: image.mediaLink != null && image.mediaLink.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: '${image.mediaLink}',
                  placeholder: (context, url) => SvgPicture.asset(
                    icon.iconName,
                  ),
                  errorWidget: (context, url, object) => SvgPicture.asset(
                    icon.iconName,
                  ),
                  fit: BoxFit.cover,
                )
              : SvgPicture.asset(
                  icon.iconName,
                ),
        ),
      );
    }).toList();
  }

  getAd(index) {
    if (ads.length - index <= 10)
      getAds().then((ads) {
        setState(() {
          this.ads.addAll(ads);
        });
      });
    if (index < ads.length) return AdWidget(ads[index]);
  }

  Future<List<AdBriefEntity>> getAds({int size}) async {
    if (!loading) {
      loading = true;
      List<AdBriefEntity> ads = await ApiService.getService().getAdByCategory(
          "${ad.ad.categoryId}, ${this.ads.length}, ${size == null ? pageSize : size}");
      loading = false;
      ads.removeWhere((ad) => ad.id == this.ad.ad.id);
      return ads;
    } else
      return [];
  }

//  Future<List<AdBriefEntity>> getAds() async {
//    return await ApiService.getService().getAdByCategory(
//        "${this.ad.ad.categoryId}, ${this.ads.length}, $pageSize");
//  }

//  getAd(index) {
//    if (ads.isEmpty || ads.length - index <= countThres) {
//      if (!loading) {
//        loading = true;
//        int start = this.ads.length;
//        //            List<Completer<AdBrief>>.filled(pageSize, Completer<AdBrief>(), growable: true));
//        ads.addAll(List<Completer<AdBriefEntity>>.generate(pageSize, (index) {
//          Completer<AdBriefEntity> completer = Completer();
//          completer.future;
//          return completer;
//        }, growable: true));
//
//        getAds().then((ads) {
//          ads.asMap().forEach((index, value) {
//            this.ads[start + index].complete(value);
//          });
//          loading = false;
//        });
//      }
//    }
//    return getFutureAd(this.ads[index]);
//  }

//  getFutureAd(Completer<AdBriefEntity> completer) {
//    return FutureBuilder(
//      future: completer.future,
//      builder: (context, snapshot) {
//        if (snapshot.connectionState == ConnectionState.done)
//          return Padding(
//            padding: const EdgeInsets.only(left: 10, right: 10),
//            child: AdWidget(snapshot.data),
//          );
//        return AdHolder();
//      },
//    );
//  }

  getSimilar(int index) {
    Widget widget = getAd(index - 3);
    if (widget != null) {
      widget = Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: widget,
      );
      if (index == 3)
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Align(
                    child: Text(
                      "Similar Ads",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Divider(color: Colors.green),
                ],
              ),
            ),
            widget
          ],
        );
      return widget;
    }
  }

  Future<AdEntity> getDetails() async {
    int id = brief.id;
    return await ApiService.getService().getAd(id);
  }
}
