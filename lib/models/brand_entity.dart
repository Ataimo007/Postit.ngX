class BrandEntity {
  int modelCount;
  String brandName;
  int id;

  BrandEntity({this.modelCount, this.brandName, this.id});

  BrandEntity.fromJson(Map<String, dynamic> json) {
    modelCount = json['model_count'];
    brandName = json['brand_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_count'] = this.modelCount;
    data['brand_name'] = this.brandName;
    data['id'] = this.id;
    return data;
  }
}
