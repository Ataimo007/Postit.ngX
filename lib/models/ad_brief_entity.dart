/// id : 2251
/// title : "Laminated flushdoor in different design and colour "
/// category_name : "Home & Garden"
/// state_name : "Abia"
/// country_name : "Nigeria"
/// city_name : "Aba"
/// seller_phone : "08035755979"
/// price : "40000.00"
/// media_name : "1568442278hirqd-img-20190913-wa0062.jpg"
/// updated_at : "2019-09-17 06:40:38"
/// media_link : "https://www.postit.ng/uploads/images/1568442278hirqd-img-20190913-wa0062.jpg"
/// media_count : 1

import 'package:intl/intl.dart';
import 'package:postit/app.dart';

class AdBriefEntity {
  int id;
  String title;
  String categoryName;
  int categoryId;
  String stateName;
  String countryName;
  String cityName;
  String sellerPhone;
  String price;
  String mediaName;
  String updatedAt;
  String mediaLink;
  int mediaCount;

  AdBriefEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
    stateName = json['state_name'];
    countryName = json['country_name'];
    cityName = json['city_name'];
    sellerPhone = json['seller_phone'];
    price = json['price'];
    mediaName = json['media_name'];
    updatedAt = json['updated_at'];
    mediaLink = json['media_link'];
    mediaCount = json['media_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['category_id'] = this.categoryId;
    data['updated_at'] = this.updatedAt;
    data['state_name'] = this.stateName;
    data['price'] = this.price;
    data['seller_phone'] = this.sellerPhone;
    data['media_link'] = this.mediaLink;
    data['id'] = this.id;
    data['media_name'] = this.mediaName;
    data['title'] = this.title;
    data['country_name'] = this.countryName;
    data['city_name'] = this.cityName;
    data['media_count'] = this.mediaCount;
    return data;
  }

  String getPrice() {
    var priceValue = double.parse(price.trim());
    if (priceValue != null) return compactMoneyFormat.format(priceValue);
    return "Not Stated";
  }

  String getTime() {
    DateTime today = DateTime.now();
    DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(updatedAt);
    if (today.difference(dateTime).inDays == 0) return "Today";
    if (today.difference(dateTime).inDays == 1) return "Yesterday";
    if (today.difference(dateTime).inDays > 1)
      return DateFormat.MMMMd("en_US").format(dateTime);
    if (today.difference(dateTime).inDays > 365)
      return DateFormat.yMMMMd("en_US").format(DateTime.now());
  }

  String getLocation() {
    return "${countryName != null ? "$countryName, " : ""}"
        "${stateName != null ? "$stateName, " : ""}"
        "${cityName != null ? "$cityName." : ""}";
  }
}
