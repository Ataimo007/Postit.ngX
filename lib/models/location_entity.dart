import 'package:postit/app.dart';

class LocationEntity {
  CountryEntity country;
  CityEntity city;
  StateEntity states;

  LocationEntity({this.country, this.city, this.states});

  LocationEntity.fromJson(Map<String, dynamic> json) {
    country = json['country'] != null
        ? new CountryEntity.fromJson(json['country'])
        : null;
    city = json['city'] != null ? new CityEntity.fromJson(json['city']) : null;
    states = json['states'] != null
        ? new StateEntity.fromJson(json['states'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.states != null) {
      data['states'] = this.states.toJson();
    }
    return data;
  }
}
