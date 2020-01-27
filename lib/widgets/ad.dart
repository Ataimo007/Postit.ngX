import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:postit/app.dart';
import 'package:url_launcher/url_launcher.dart';

class AdWidget extends StatelessWidget {
  final AdBriefEntity _ad;
  final bool isUser;
  final bool isInActive;
  final Function() refresh;
  CategoryIcon icon;

  AdWidget(this._ad,
      {this.isUser = false, this.isInActive = false, this.refresh}) {
    icon = CategoryIcon.getCategory(_ad.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        color: Colors.white,
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Stack(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                    minHeight: 250,
                    maxHeight: 350,
                    minWidth: double.infinity,
                    maxWidth: double.infinity),
                child: _ad.mediaLink != null &&
                        _ad.mediaLink.isNotEmpty &&
                        _ad.mediaCount != 0
                    ? CachedNetworkImage(
                        imageUrl: '${_ad.mediaLink}',
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
              Positioned(
                child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          _ad.title.trim(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: isUser && !isInActive ? 0 : 12,
                              bottom: isUser && !isInActive ? 0 : 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _ad.getPrice(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                    fontSize: 16),
                              ),
                              Spacer(),
                              ..._getOptionWidgets(context),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10,
                            runAlignment: WrapAlignment.start,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: <Widget>[
                              _getBriefDetail(_ad.getLocation(),
                                  Icons.location_on, Colors.red),
                              _getBriefDetail(_ad.getTime(), Icons.access_time,
                                  Colors.black),
                              _getBriefDetail(_ad.mediaCount.toString(),
                                  Icons.photo_camera, Colors.black),
                            ],
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.white.withOpacity(0.9),
                            Colors.white.withOpacity(0.7),
                          ]),
                    )),
                left: 0,
                bottom: 0,
                right: 0,
              ),
            ],
          ),
        ),
      ),
      onTap: () => Navigator.pushNamed(context, "ad/details", arguments: _ad),
    );
  }

  _getOptionWidgets(BuildContext context) {
    if (isUser) if (isInActive)
      return _getUserInactiveWidgets(context);
    else
      return _getUserWidgets(context);
    else
      return _getGeneralWidgets();
  }

  _getGeneralWidgets() {
    return <Widget>[
      InkWell(
          onTap: () {
            launch("tel:${_ad.sellerPhone}");
          },
          child: Icon(Icons.call, color: Colors.green)),
      SizedBox(
        width: 30,
      ),
      InkWell(
          onTap: () {}, child: Icon(Icons.favorite_border, color: Colors.red)),
      SizedBox(
        width: 10,
      ),
    ];
  }

  _getUserWidgets(BuildContext context) {
    return <Widget>[
      InkWell(
          onTap: () {
            Navigator.pushNamed(context, PostAd.routeName, arguments: _ad.id)
                .then((value) => refresh());
          },
          child: Icon(Icons.edit, color: Colors.green)),
      SizedBox(
        width: 20,
      ),
      PopupMenuButton<Function>(
        onSelected: (action) => action(),
        itemBuilder: (context) => <PopupMenuEntry<Function>>[
          PopupMenuItem<Function>(
            child: Text("Refresh Ad"),
            value: () {
              ApiService.getService()
                  .refreshAd(_ad.id)
                  .then((value) => refresh());
            },
          ),
          PopupMenuItem<Function>(
            child: Text("Close Ad"),
            value: () {
              ApiService.getService()
                  .closeAd(_ad.id)
                  .then((value) => refresh());
            },
          ),
          PopupMenuItem<Function>(
            child: Text("Delete Ad"),
            value: () {
              ApiService.getService()
                  .deleteAd(_ad.id)
                  .then((value) => refresh());
            },
          )
        ],
      ),
    ];
  }

  _getUserInactiveWidgets(BuildContext context) {
    return <Widget>[
      InkWell(
          onTap: () {
            ApiService.getService().deleteAd(_ad.id).then((value) => refresh());
          },
          child: Icon(Icons.delete, color: Colors.red)),
      SizedBox(
        width: 20,
      ),
    ];
  }

  _getBriefDetail(String info, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          info,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class AdHolder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      color: Colors.white,
      child: Container(
        height: 250,
        margin: EdgeInsets.all(2),
      ),
    );
  }
}
