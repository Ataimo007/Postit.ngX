class BodyStyleEntity {
  String bodyStyleName;
  int categoryId;
  int id;

  BodyStyleEntity({this.bodyStyleName, this.categoryId, this.id});

  BodyStyleEntity.fromJson(Map<String, dynamic> json) {
    bodyStyleName = json['body_style_name'];
    categoryId = json['category_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body_style_name'] = this.bodyStyleName;
    data['category_id'] = this.categoryId;
    data['id'] = this.id;
    return data;
  }
}
