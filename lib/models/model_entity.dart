class ModelEntity {
  String modelName;
  int id;

  ModelEntity({this.modelName, this.id});

  ModelEntity.fromJson(Map<String, dynamic> json) {
    modelName = json['model_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_name'] = this.modelName;
    data['id'] = this.id;
    return data;
  }
}
