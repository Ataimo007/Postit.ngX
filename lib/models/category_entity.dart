class CategoryEntity {
  String categoryName;
  int id;
  int subCategoryCount;

  CategoryEntity({this.categoryName, this.id, this.subCategoryCount});

  CategoryEntity.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    id = json['id'];
    subCategoryCount = json['sub_category_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['id'] = this.id;
    data['sub_category_count'] = this.subCategoryCount;
    return data;
  }
}
