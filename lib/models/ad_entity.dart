import 'package:intl/intl.dart';
import 'package:postit/app.dart';

class AdEntity {
  List<AdMedia> medias;
  AdAd ad;

  AdEntity({this.medias, this.ad});

  AdEntity.fromJson(Map<String, dynamic> json) {
    if (json['medias'] != null) {
      medias = new List<AdMedia>();
      (json['medias'] as List).forEach((v) {
        medias.add(new AdMedia.fromJson(v));
      });
    }
    ad = json['ad'] != null ? new AdAd.fromJson(json['ad']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medias != null) {
      data['medias'] = this.medias.map((v) => v.toJson()).toList();
    }
    if (this.ad != null) {
      data['ad'] = this.ad.toJson();
    }
    return data;
  }
}

class AdMedia {
  String updatedAt;
  String mediaLink;
  String mediaName;

  AdMedia({this.updatedAt, this.mediaLink, this.mediaName});

  AdMedia.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated_at'];
    mediaLink = json['media_link'];
    mediaName = json['media_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_at'] = this.updatedAt;
    data['media_link'] = this.mediaLink;
    data['media_name'] = this.mediaName;
    return data;
  }
}

class AdAd {
  String sellerEmail;
  String categoryName;
  String address;
  String description;
  String brandName;
  String title;
  String adCondition;
  String cityName;
  String bodyStyleName;
  String transmission;
  int categoryId;
  String sellerName;
  String modelName;
  String updatedAt;
  String stateName;
  String price;
  String countryName;
  String sellerPhone;
  int id;

  AdAd(
      {this.sellerEmail,
      this.categoryName,
      this.address,
      this.description,
      this.brandName,
      this.title,
      this.adCondition,
      this.cityName,
      this.bodyStyleName,
      this.transmission,
      this.categoryId,
      this.sellerName,
      this.modelName,
      this.updatedAt,
      this.stateName,
      this.price,
      this.countryName,
      this.sellerPhone,
      this.id});

  AdAd.fromJson(Map<String, dynamic> json) {
    sellerEmail = json['seller_email'];
    categoryName = json['category_name'];
    address = json['address'];
    description = json['description'];
    brandName = json['brand_name'];
    title = json['title'];
    adCondition = json['ad_condition'];
    cityName = json['city_name'];
    bodyStyleName = json['body_style_name'];
    transmission = json['transmission'];
    categoryId = json['category_id'];
    sellerName = json['seller_name'];
    modelName = json['model_name'];
    updatedAt = json['updated_at'];
    stateName = json['state_name'];
    price = json['price'];
    countryName = json['country_name'];
    sellerPhone = json['seller_phone'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seller_email'] = this.sellerEmail;
    data['category_name'] = this.categoryName;
    data['address'] = this.address;
    data['description'] = this.description;
    data['brand_name'] = this.brandName;
    data['title'] = this.title;
    data['ad_condition'] = this.adCondition;
    data['city_name'] = this.cityName;
    data['body_style_name'] = this.bodyStyleName;
    data['transmission'] = this.transmission;
    data['category_id'] = this.categoryId;
    data['seller_name'] = this.sellerName;
    data['model_name'] = this.modelName;
    data['updated_at'] = this.updatedAt;
    data['state_name'] = this.stateName;
    data['price'] = this.price;
    data['country_name'] = this.countryName;
    data['seller_phone'] = this.sellerPhone;
    data['id'] = this.id;
    return data;
  }

  String getPrice() {
    var priceValue = double.parse(price.trim());
    if (priceValue != null) return compactMoneyFormat.format(priceValue);
    return "Not Stated";
  }

  String getFullPrice() {
    var priceValue = double.parse(price.trim());
    if (priceValue != null) return decimalMoneyFormat.format(priceValue);
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

    return "";
  }

  String getFullTime() {
    DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(updatedAt);
    return DateFormat.yMMMMd("en_US").format(dateTime);
  }

  String getLocation() {
    return "${countryName != null ? "$countryName, " : ""}"
        "${stateName != null ? "$stateName, " : ""}"
        "${cityName != null ? "$cityName." : ""}";
  }
}
