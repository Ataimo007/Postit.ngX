class StateEntity {
  int stateCount;
  String stateName;
  int id;
  int countryId;

  StateEntity({this.stateCount, this.stateName, this.id, this.countryId});

  StateEntity.fromJson(Map<String, dynamic> json) {
    stateCount = json['state_count'];
    stateName = json['state_name'];
    id = json['id'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_count'] = this.stateCount;
    data['state_name'] = this.stateName;
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    return data;
  }
}
