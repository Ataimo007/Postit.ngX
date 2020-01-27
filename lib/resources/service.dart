import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:postit/app.dart';
import 'package:postit/models/login_user_entity.dart';

class ApiService {
  static ApiService _apiService;
  static final options = BaseOptions(baseUrl: "https://www.postit.ng/api/");
  static final _dio = Dio(options);

  static ApiService getService() {
    if (_apiService == null) _apiService = ApiService();
    return _apiService;
  }

  ApiService() {
    _dio.interceptors.add(
        LogInterceptor(responseBody: true, request: true, requestHeader: true));
  }

  Future<List<AdBriefEntity>> getAds(String params) async {
    final String path = "ads/brief/$params";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<AdBriefEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => AdBriefEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<AdBriefEntity>> getAdsBySearch(Map<String, dynamic> query) async {
    final String path = "ads/search_brief";
    Response<Map<String, dynamic>> response =
        await _dio.post(path, data: query);
    List<AdBriefEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => AdBriefEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<AdBriefEntity>> getUserAdsByStates(String params) async {
    final String path = "user/statedAds/brief/$params";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<AdBriefEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => AdBriefEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<AdEntity> getAd(int id) async {
    final String path = "ads/full/$id";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    AdEntity ad =
        AdEntity.fromJson((response.data['result'] as Map<String, dynamic>));
    return ad;
  }

  Future<List<AdBriefEntity>> getAdByCategory(String options) async {
    final String path = "ads/category_brief/$options";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<AdBriefEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => AdBriefEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<CategoryEntity>> getCategories() async {
    final String path = "info/get_categories";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<CategoryEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => CategoryEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<TransmissionEntity>> getTransmissions() async {
    final String path = "info/get_transmissions";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<TransmissionEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => TransmissionEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<BrandEntity>> getBrand(int options) async {
    final String path = "info/get_brands/$options";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<BrandEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => BrandEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<ModelEntity>> getModel(int options) async {
    final String path = "info/get_models/$options";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<ModelEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => ModelEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<BodyStyleEntity>> getBodyStyle() async {
    final String path = "info/get_body_styles";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<BodyStyleEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => BodyStyleEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<LocationEntity> getAddress(
      String country, String code, String state, String city) async {
    final String path = "info/get_address";
    Response<Map<String, dynamic>> response = await _dio.get(path,
        queryParameters: {
          'country': country,
          'country_code': code,
          'state': state,
          'city': city
        });
    LocationEntity location = LocationEntity.fromJson(response.data['result']);
    return location;
  }

  Future<List<CountryEntity>> getCountry() async {
    final String path = "info/get_countries";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<CountryEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => CountryEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<StateEntity>> getStates(int countryId) async {
    final String path = "info/get_states/$countryId";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<StateEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => StateEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<CityEntity>> getCities(int stateId) async {
    final String path = "info/get_cities/$stateId";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<CityEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => CityEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<List<SubCategoryEntity>> getSubCategories(int id) async {
    final String path = "info/get_sub_categories/$id";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    List<SubCategoryEntity> ads = (response.data['result'] as List<dynamic>)
        .map((value) => SubCategoryEntity.fromJson(value))
        .toList();
    return ads;
  }

  Future<AdFullEntity> getAdFull(int id) async {
    final String path = "ads/fullInfo/$id";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    AdFullEntity ad = AdFullEntity.fromJson(response.data);
    return ad;
  }

  Future<UserEntity> getUser(int id, String email) async {
    final String path = "user/get";
    Response<Map<String, dynamic>> response =
        await _dio.get(path, queryParameters: {'id': id, 'email': email});
    UserEntity user = UserEntity.fromJson(response.data['result']);
    return user;
  }

  Future<PostMessageEntity> postAd(Map<String, dynamic> ad) async {
    final String path = "ads/post";
    Response<Map<String, dynamic>> response = await _dio.post(path, data: ad);
    PostMessageEntity ads = PostMessageEntity.fromJson(response.data);
    return ads;
  }

  Future<MessageEntity> deleteAd(int id) async {
    final String path = "user/ads/delete/$id";
    Response<Map<String, dynamic>> response = await _dio.post(path);
    MessageEntity msg = MessageEntity.fromJson(response.data);
    return msg;
  }

  Future<MessageEntity> closeAd(int id) async {
    final String path = "user/ads/close/$id";
    Response<Map<String, dynamic>> response = await _dio.post(path);
    MessageEntity msg = MessageEntity.fromJson(response.data);
    return msg;
  }

  Future<MessageEntity> refreshAd(int id) async {
    final String path = "user/ads/refresh/$id";
    Response<Map<String, dynamic>> response = await _dio.post(path);
    MessageEntity msg = MessageEntity.fromJson(response.data);
    return msg;
  }

  Future<MessageEntity> editAd(Map<String, dynamic> ad) async {
    final String path = "user/ads/edit/${ad['ad_id']}";
    Response<Map<String, dynamic>> response = await _dio.post(path, data: ad);
    MessageEntity ads = MessageEntity.fromJson(response.data);
    return ads;
  }

  Future<MediaMessageEntity> postAdImage(
      int adId, int userId, File adImage) async {
    final String path = "user/ads/upload_image";

    Map<String, dynamic> details = {'ad_id': adId, 'user_id': userId};
    details['file_uploads'] = await MultipartFile.fromFile(adImage.path,
        contentType: MediaType("image", "jpg"));

    FormData formData = FormData.fromMap(details);

    Response<Map<String, dynamic>> response = await _dio.post(path,
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType));

    MediaMessageEntity ads = MediaMessageEntity.fromJson(response.data);
    return ads;
  }

  Future<MessageEntity> register(
      Map<String, dynamic> user, File profilePic) async {
    final String path = "user/register";

    user['file_uploads'] = await MultipartFile.fromFile(profilePic.path,
        contentType: MediaType("image", "jpg"));

    FormData formData = FormData.fromMap(user);

    Response<Map<String, dynamic>> response = await _dio.post(path,
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType));

    MessageEntity ads = MessageEntity.fromJson(response.data);
    return ads;
  }

  Future<LoginUserEntity> updateUser(
      Map<String, dynamic> user, File profilePic) async {
    final String path = "user/update";

    if (profilePic != null)
      user['file_uploads'] = await MultipartFile.fromFile(profilePic.path,
          contentType: MediaType("image", "jpg"));

    FormData formData = FormData.fromMap(user);

    Response<Map<String, dynamic>> response = await _dio.post(path,
        data: formData,
        options: Options(contentType: Headers.formUrlEncodedContentType));

    LoginUserEntity updatedUser = LoginUserEntity.fromJson(response.data);
    return updatedUser;
  }

  Future<dynamic> login(Map<String, dynamic> details) async {
    dynamic login;
    final String path = "user/login";
    Response<Map<String, dynamic>> response =
        await _dio.post(path, data: details);

    login = response.data['success']
        ? LoginUserEntity.fromJson(response.data)
        : MessageEntity.fromJson(response.data);

    return login;
  }
}
