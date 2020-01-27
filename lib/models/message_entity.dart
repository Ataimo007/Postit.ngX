class MessageEntity {
  String result;
  bool success;

  MessageEntity({this.result, this.success});

  MessageEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['success'] = this.success;
    return data;
  }

  @override
  String toString() {
    return 'MessageEntity{result: $result, success: $success}';
  }
}
