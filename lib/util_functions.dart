import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final moneyFormat =
    NumberFormat.simpleCurrency(locale: 'en_Us', name: 'NGN', decimalDigits: 0);

final numberFormat = NumberFormat("#,###", "en_US");

final compactMoneyFormat = NumberFormat.compactSimpleCurrency(
    locale: 'en_Us', name: 'NGN', decimalDigits: 2);
final decimalMoneyFormat =
    NumberFormat.simpleCurrency(locale: 'en_Us', name: 'NGN', decimalDigits: 2);

showToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 2,
      backgroundColor: Colors.green.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0);
}

String capitalizeFirst(String s) => s[0].toUpperCase() + s.substring(1);

class CategoryIcon {
  final int id;
  final String name;
  final String image;

  static final List<CategoryIcon> values = [
    CategoryIcon(11, "Business, Services & Industry", "business"),
    CategoryIcon(7, "Car & Vehicles", "car"),
    CategoryIcon(10, "Education", "education"),
    CategoryIcon(1, "Electronics", "elect"),
    CategoryIcon(18, "Fashion & Beauty", "fashion"),
    CategoryIcon(12, "Food & Agriculture", "agric"),
    CategoryIcon(19, "Health", "health"),
    CategoryIcon(6, "Home & Garden", "home"),
    CategoryIcon(115, "Jobs", "job"),
    CategoryIcon(46, "Medical Supplies & Equipment", "med"),
    CategoryIcon(20, "Other", "others"),
    CategoryIcon(9, "Pets & Animals", "pet"),
    CategoryIcon(3, "Property", "property"),
  ];

  CategoryIcon(this.id, this.name, this.image);

  String get iconName => "assets/cat_icons/icon_$image.svg";

  String get altIconName => "assets/cat_icons/icon_${image}_alt.svg";

  bool operator ==(other) => other is CategoryIcon && id == other.id;

  int get hashCode => id.hashCode;

  static CategoryIcon getCategory(int id) {
    return values.firstWhere((cat) {
      return cat.id == id;
    });
  }
}
