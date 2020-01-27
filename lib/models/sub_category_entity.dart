class SubCategoryEntity {
  String categoryName;
  bool hasTrans;
  bool hasBodyStyle;
  int brandCount;
  int id;

  SubCategoryEntity(
      {this.categoryName,
      this.brandCount,
      this.id,
      this.hasTrans,
      this.hasBodyStyle});

  SubCategoryEntity.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    brandCount = json['brand_count'];
    hasTrans = json['has_trans'] == "1";
    hasBodyStyle = json['has_body_style'] == "1";
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['brand_count'] = this.brandCount;
    data['has_trans'] = hasTrans ? "1" : "0";
    data['has_body_style'] = hasBodyStyle ? "1" : "0";
    data['id'] = this.id;
    return data;
  }

  @override
  String toString() {
    return 'SubCategoryEntity{categoryName: $categoryName, hasTrans: $hasTrans, hasBodyStyle: $hasBodyStyle, brandCount: $brandCount, id: $id}';
  }
}
