class PostMessageEntity {
  PostMessageResult result;
  bool success;

  PostMessageEntity({this.result, this.success});

  PostMessageEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new PostMessageResult.fromJson(json['result'])
        : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class PostMessageResult {
  int adId;
  String message;

  PostMessageResult({this.adId, this.message});

  PostMessageResult.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_id'] = this.adId;
    data['message'] = this.message;
    return data;
  }
}
