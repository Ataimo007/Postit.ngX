class CityEntity {
  String cityName;
  int id;
  int stateId;

  CityEntity({this.cityName, this.id, this.stateId});

  CityEntity.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    id = json['id'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_name'] = this.cityName;
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    return data;
  }
}
