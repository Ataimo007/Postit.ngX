import 'package:postit/models/ad_brief_entity.dart';
import 'package:postit/models/ad_entity.dart';
import 'package:postit/models/ad_full_entity.dart';
import 'package:postit/models/body_style_entity.dart';
import 'package:postit/models/brand_entity.dart';
import 'package:postit/models/category_entity.dart';
import 'package:postit/models/city_entity.dart';
import 'package:postit/models/country_entity.dart';
import 'package:postit/models/geocoding_response_entity.dart';
import 'package:postit/models/location_entity.dart';
import 'package:postit/models/login_user_entity.dart';
import 'package:postit/models/media_message_entity.dart';
import 'package:postit/models/message_entity.dart';
import 'package:postit/models/model_entity.dart';
import 'package:postit/models/post_message_entity.dart';
import 'package:postit/models/state_entity.dart';
import 'package:postit/models/sub_category_entity.dart';
import 'package:postit/models/transmission_entity.dart';
import 'package:postit/models/user_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "AdBriefEntity") {
      return AdBriefEntity.fromJson(json) as T;
    } else if (T.toString() == "AdEntity") {
      return AdEntity.fromJson(json) as T;
    } else if (T.toString() == "AdFullEntity") {
      return AdFullEntity.fromJson(json) as T;
    } else if (T.toString() == "BodyStyleEntity") {
      return BodyStyleEntity.fromJson(json) as T;
    } else if (T.toString() == "BrandEntity") {
      return BrandEntity.fromJson(json) as T;
    } else if (T.toString() == "CategoryEntity") {
      return CategoryEntity.fromJson(json) as T;
    } else if (T.toString() == "CityEntity") {
      return CityEntity.fromJson(json) as T;
    } else if (T.toString() == "CountryEntity") {
      return CountryEntity.fromJson(json) as T;
    } else if (T.toString() == "GeocodingResponseEntity") {
      return GeocodingResponseEntity.fromJson(json) as T;
    } else if (T.toString() == "LocationEntity") {
      return LocationEntity.fromJson(json) as T;
    } else if (T.toString() == "LoginUserEntity") {
      return LoginUserEntity.fromJson(json) as T;
    } else if (T.toString() == "MediaMessageEntity") {
      return MediaMessageEntity.fromJson(json) as T;
    } else if (T.toString() == "MessageEntity") {
      return MessageEntity.fromJson(json) as T;
    } else if (T.toString() == "ModelEntity") {
      return ModelEntity.fromJson(json) as T;
    } else if (T.toString() == "PostMessageEntity") {
      return PostMessageEntity.fromJson(json) as T;
    } else if (T.toString() == "StateEntity") {
      return StateEntity.fromJson(json) as T;
    } else if (T.toString() == "SubCategoryEntity") {
      return SubCategoryEntity.fromJson(json) as T;
    } else if (T.toString() == "TransmissionEntity") {
      return TransmissionEntity.fromJson(json) as T;
    } else if (T.toString() == "UserEntity") {
      return UserEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}