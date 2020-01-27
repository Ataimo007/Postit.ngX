import 'package:postit/app.dart';

class AdFullEntity {
  AdFullResult result;
  bool success;

  AdFullEntity({this.result, this.success});

  AdFullEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new AdFullResult.fromJson(json['result'])
        : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['success'] = this.success;
    return data;
  }

  CategoryEntity getCategory() {
    return CategoryEntity(
        id: result.ad.categoryId, categoryName: result.ad.categoryName);
  }

  SubCategoryEntity getSubCategory() {
    return SubCategoryEntity(
        id: result.ad.subCategoryId,
        categoryName: result.ad.subCategoryName,
        hasBodyStyle:
            result.ad.bodyStyleId == null ? false : result.ad.bodyStyleId != 0,
        hasTrans: result.ad.bodyStyleId == null
            ? false
            : result.ad.transmissionId != 0,
        brandCount: result.ad.brandCount);
  }

  BrandEntity getBrand() {
    return BrandEntity(
        id: result.ad.brandId,
        brandName: result.ad.brandName,
        modelCount: result.ad.modelCount);
  }

  ModelEntity getModel() {
    return ModelEntity(
        id: result.ad.brandModelId, modelName: result.ad.modelName);
  }

  BodyStyleEntity getBodyStyle() {
    return BodyStyleEntity(
        id: result.ad.bodyStyleId,
        bodyStyleName: result.ad.bodyStyleName,
        categoryId: result.ad.categoryId);
  }

  TransmissionEntity getTransmission() {
    return TransmissionEntity(
        id: result.ad.transmissionId,
        transmission: result.ad.transmission,
        categoryId: result.ad.categoryId);
  }

  Condition getCondition() {
    Condition condition = Condition.values.where((condition) {
      return condition.toString().toLowerCase().contains(result.ad.adCondition);
    }).elementAt(0);
    return condition;
  }

  Type getType() {
    Type condition = Type.values.where((type) {
      return type.toString().toLowerCase().contains(result.ad.type);
    }).elementAt(0);
    return condition;
  }

  List<dynamic> getRegion() {
    return [
      CountryEntity(
          id: result.ad.countryId, countryName: result.ad.countryName),
      StateEntity(id: result.ad.stateId, stateName: result.ad.stateName),
      CityEntity(id: result.ad.cityId, cityName: result.ad.cityName)
    ];
  }

  String getPrice() {
    double price = double.tryParse(result.ad.price.trim());
    if (price != null)
      return moneyFormat.format(price);
    else
      return result.ad.price.trim();
  }

  String getMileage() {
    double price = double.tryParse(result.ad.mileage.trim());
    if (price != null)
      return numberFormat.format(price);
    else
      return result.ad.price.trim();
  }

  String getTitle() {
    return result.ad.title.trim();
  }

  List<AdFullResultMedia> getImages() => result.medias;

  T getInitial<T>(String name) {
    switch (name) {
      case 'Category':
        return [getCategory(), getSubCategory()] as T;
        break;

      case 'Brand':
        return getBrand() as T;
        break;

      case 'Model':
        return getModel() as T;
        break;

      case 'Year':
        return DateTime(result.ad.year) as T;
        break;

      case 'Body Style':
        return getBodyStyle() as T;
        break;

      case 'Transmissions':
        return getTransmission() as T;
        break;

      case 'Condition Of Ad':
        return getCondition() as T;
        break;

      case 'Mileage':
        return getMileage() as T;
        break;

      case 'Ad Title':
        return result.ad.title as T;
        break;

      case 'Region':
        return getRegion() as T;
        break;

      case 'Description':
        return result.ad.description as T;
        break;

      case 'Type of Ad':
        return getType() as T;
        break;

      case 'Price':
        return getPrice() as T;
        break;

      case 'Negotiable':
        return (result.ad.isNegotiable == "1") as T;
        break;

      case 'Address':
        return result.ad.address as T;
        break;

      default:
        return null;
    }
  }
}

class AdFullResult {
  List<AdFullResultMedia> medias;
  AdFullResultAd ad;

  AdFullResult({this.medias, this.ad});

  AdFullResult.fromJson(Map<String, dynamic> json) {
    if (json['medias'] != null) {
      medias = new List<AdFullResultMedia>();
      (json['medias'] as List).forEach((v) {
        medias.add(new AdFullResultMedia.fromJson(v));
      });
    }
    ad = json['ad'] != null ? new AdFullResultAd.fromJson(json['ad']) : null;
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

class AdFullResultMedia {
  String updatedAt;
  String mediaLink;
  int id;
  String mediaName;

  AdFullResultMedia({this.updatedAt, this.mediaLink, this.id, this.mediaName});

  AdFullResultMedia.fromJson(Map<String, dynamic> json) {
    updatedAt = json['updated_at'];
    mediaLink = json['media_link'];
    id = json['id'];
    mediaName = json['media_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_at'] = this.updatedAt;
    data['media_link'] = this.mediaLink;
    data['id'] = this.id;
    data['media_name'] = this.mediaName;
    return data;
  }
}

class AdFullResultAd {
  String sellerEmail;
  String categoryName;
  int year;
  String description;
  String title;
  String type;
  int bodyStyleId;
  String cityName;
  dynamic bodyStyleName;
  dynamic transmission;
  int categoryId;
  String sellerName;
  String modelName;
  String updatedAt;
  String stateName;
  int subCategoryId;
  String price;
  int modelCount;
  String subCategoryName;
  String countryName;
  String sellerPhone;
  int id;
  int stateId;
  int transmissionId;
  String mileage;
  String address;
  String isNegotiable;
  String brandName;
  int brandModelId;
  int brandId;
  String adCondition;
  int brandCount;
  int countryId;
  int cityId;

  AdFullResultAd(
      {this.sellerEmail,
      this.categoryName,
      this.year,
      this.description,
      this.title,
      this.type,
      this.bodyStyleId,
      this.cityName,
      this.bodyStyleName,
      this.transmission,
      this.categoryId,
      this.sellerName,
      this.modelName,
      this.updatedAt,
      this.stateName,
      this.subCategoryId,
      this.price,
      this.modelCount,
      this.subCategoryName,
      this.countryName,
      this.sellerPhone,
      this.id,
      this.stateId,
      this.transmissionId,
      this.mileage,
      this.address,
      this.isNegotiable,
      this.brandName,
      this.brandModelId,
      this.brandId,
      this.adCondition,
      this.brandCount,
      this.countryId,
      this.cityId});

  AdFullResultAd.fromJson(Map<String, dynamic> json) {
    sellerEmail = json['seller_email'];
    categoryName = json['category_name'];
    year = json['year'];
    description = json['description'];
    title = json['title'];
    type = json['type'];
    bodyStyleId = json['body_style_id'];
    cityName = json['city_name'];
    bodyStyleName = json['body_style_name'];
    transmission = json['transmission'];
    categoryId = json['category_id'];
    sellerName = json['seller_name'];
    modelName = json['model_name'];
    updatedAt = json['updated_at'];
    stateName = json['state_name'];
    subCategoryId = json['sub_category_id'];
    price = json['price'];
    modelCount = json['model_count'];
    subCategoryName = json['sub_category_name'];
    countryName = json['country_name'];
    sellerPhone = json['seller_phone'];
    id = json['id'];
    stateId = json['state_id'];
    transmissionId = json['transmission_id'];
    mileage = json['mileage'];
    address = json['address'];
    isNegotiable = json['is_negotiable'];
    brandName = json['brand_name'];
    brandModelId = json['brand_model_id'];
    brandId = json['brand_id'];
    adCondition = json['ad_condition'];
    brandCount = json['brand_count'];
    countryId = json['country_id'];
    cityId = json['city_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seller_email'] = this.sellerEmail;
    data['category_name'] = this.categoryName;
    data['year'] = this.year;
    data['description'] = this.description;
    data['title'] = this.title;
    data['type'] = this.type;
    data['body_style_id'] = this.bodyStyleId;
    data['city_name'] = this.cityName;
    data['body_style_name'] = this.bodyStyleName;
    data['transmission'] = this.transmission;
    data['category_id'] = this.categoryId;
    data['seller_name'] = this.sellerName;
    data['model_name'] = this.modelName;
    data['updated_at'] = this.updatedAt;
    data['state_name'] = this.stateName;
    data['sub_category_id'] = this.subCategoryId;
    data['price'] = this.price;
    data['model_count'] = this.modelCount;
    data['sub_category_name'] = this.subCategoryName;
    data['country_name'] = this.countryName;
    data['seller_phone'] = this.sellerPhone;
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    data['transmission_id'] = this.transmissionId;
    data['mileage'] = this.mileage;
    data['address'] = this.address;
    data['is_negotiable'] = this.isNegotiable;
    data['brand_name'] = this.brandName;
    data['brand_model_id'] = this.brandModelId;
    data['brand_id'] = this.brandId;
    data['ad_condition'] = this.adCondition;
    data['brand_count'] = this.brandCount;
    data['country_id'] = this.countryId;
    data['city_id'] = this.cityId;
    return data;
  }
}
