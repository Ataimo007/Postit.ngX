class MediaMessageEntity {
  MediaMessageResult result;
  bool success;

  MediaMessageEntity({this.result, this.success});

  MediaMessageEntity.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null
        ? new MediaMessageResult.fromJson(json['result'])
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

class MediaMessageResult {
  String adId;
  String userId;
  int mediaId;

  MediaMessageResult({this.adId, this.userId, this.mediaId});

  MediaMessageResult.fromJson(Map<String, dynamic> json) {
    adId = json['ad_id'];
    userId = json['user_id'];
    mediaId = json['media_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_id'] = this.adId;
    data['user_id'] = this.userId;
    data['media_id'] = this.mediaId;
    return data;
  }
}
