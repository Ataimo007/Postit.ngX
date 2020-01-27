class TransmissionEntity {
  String transmission;
  int categoryId;
  int id;

  TransmissionEntity({this.transmission, this.categoryId, this.id});

  TransmissionEntity.fromJson(Map<String, dynamic> json) {
    transmission = json['transmission'];
    categoryId = json['category_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transmission'] = this.transmission;
    data['category_id'] = this.categoryId;
    data['id'] = this.id;
    return data;
  }

  bool operator ==(other) => other is TransmissionEntity && id == other.id;

  int get hashCode => id.hashCode;
}
