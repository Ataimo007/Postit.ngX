import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postit/app.dart';

class AdList extends StatefulWidget {
  final SearchController controller;

  const AdList({Key key, this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AdList(controller: controller);
  }
}

class _AdList extends State<AdList> {
  final ads = List<AdBriefEntity>();

  static const pageSize = 30;
  static const firstPage = 50;
  static const countThres = 20;
  bool loading = false;

  Map<String, dynamic> search;
  final SearchController controller;
  Future<List<AdBriefEntity>> currentSearch;

  _AdList({this.controller});

  @override
  void initState() {
    super.initState();
    if (controller != null) {
      controller._initialization((search) {
        this.search = search;
        _refresh(isSearch: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (ads.isEmpty)
      getAds(size: firstPage).then((ads) {
        setState(() {
          this.ads.addAll(ads);
        });
      });

    if (ads.isEmpty)
      return Container();
    else
      return Container(
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) => getAd(index),
          ),
          onRefresh: _refresh,
        ),
        constraints: BoxConstraints.expand(),
      );
  }

  Future<Null> _refresh({bool isSearch = false}) {
    ads.clear();
    return getAds(size: firstPage, isSearch: isSearch).then((ads) {
      setState(() {
        this.ads.addAll(ads);
      });
    });
  }

  getAd(index) {
    if (ads.length - index <= 10)
      getAds().then((ads) {
        if (ads.isNotEmpty) {
          setState(() {
            this.ads.addAll(ads);
          });
        }
      });
    if (index < ads.length) return AdWidget(ads[index]);
  }

  Future<List<AdBriefEntity>> getAds({int size, bool isSearch = false}) async {
    if (!loading || isSearch) {
      loading = true;
      Future<List<AdBriefEntity>> futureAds = retrieveAds(size: size);
      List<AdBriefEntity> ads = await futureAds;
      loading = false;
      if (isSearch) {
        if (futureAds == currentSearch)
          return ads;
        else
          return [];
      } else
        return ads;
    } else
      return [];
  }

  Future<List<AdBriefEntity>> retrieveAds({int size}) async {
    if (search != null) {
      search['begin'] = this.ads.length;
      search['count'] = size == null ? pageSize : size;
      Future<List<AdBriefEntity>> searching =
          ApiService.getService().getAdsBySearch(search);
      currentSearch = searching;
      return searching;
    } else
      return ApiService.getService()
          .getAds("${this.ads.length}, ${size == null ? pageSize : size}");
  }
}

class SearchController {
  final Map<String, dynamic> params = {};
  void Function(Map<String, dynamic> params) search;

  SearchController();

  void _initialization(Function(Map<String, dynamic> params) search) {
    this.search = search;
  }

  void textSearch(String query) {
    params['search'] = query;
    _beginSearch();
  }

  void _beginSearch() {
    search(params);
  }
}
