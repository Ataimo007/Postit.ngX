import 'package:postit/app.dart';

class LoginUserEntity {
  UserEntity result;
  bool success;

  LoginUserEntity({this.result, this.success});

  LoginUserEntity.fromJson(Map<String, dynamic> json) {
    result =
        json['result'] != null ? new UserEntity.fromJson(json['result']) : null;
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

  @override
  String toString() {
    return 'LoginUserEntity{result: $result, success: $success}';
  }
}
