class CountryEntity {
  int stateCount;
  String countryName;
  int id;

  CountryEntity({this.stateCount, this.countryName, this.id});

  CountryEntity.fromJson(Map<String, dynamic> json) {
    stateCount = json['state_count'];
    countryName = json['country_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_count'] = this.stateCount;
    data['country_name'] = this.countryName;
    data['id'] = this.id;
    return data;
  }

  @override
  String toString() {
    return 'CountryEntity{stateCount: $stateCount, countryName: $countryName, id: $id}';
  }
}
