import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postit/app.dart';

class GeocodingService {
  static GeocodingService _geocodingService;
  static final options = BaseOptions();
  static final _dio = Dio(options);

  static const String apiKey = 'AIzaSyBm1XfRfkv4NatxCEAAJSu9zmaX3zPVC4o';

  static GeocodingService getService() {
    if (_geocodingService == null) _geocodingService = GeocodingService();
    return _geocodingService;
  }

  GeocodingService() {
    _dio.interceptors.add(
        LogInterceptor(responseBody: true, request: true, requestHeader: true));
  }

  static Future<GeocodingResponseEntity> getLocation(
      double lat, double long) async {
    return getService().getAddress(lat, long);
  }

  static Future<GeocodingResponseEntity> getPositionAddress(Position position) {
    return getService().getAddress(position.latitude, position.longitude);
  }

  Future<GeocodingResponseEntity> getAddress(double lat, double long) async {
    final String path =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apiKey";
    Response<Map<String, dynamic>> response = await _dio.get(path);
    GeocodingResponseEntity address =
        GeocodingResponseEntity.fromJson(response.data);
    return address;
  }
}
