import 'dart:convert';

UserModel UserModelJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    required this.loginId,
    required this.loginPassword,
    required this.name,
    required this.stamp_cnt,
    required this.token,
  });

  int? id;
  int stamp_cnt;
  String loginId;
  String loginPassword;
  String name;
  String token;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0, // null일 경우 기본값 0 설정
        loginId: json["loginId"] ?? "",
        loginPassword: json["loginPassword"] ?? "",
        name: json["name"] ?? "",
        stamp_cnt: json["stampCnt"] ?? 0, // null일 경우 기본값 0 설정
        token: json["token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loginId": loginId,
        "loginPassword": loginPassword,
        "name": name,
        "stampCnt": stampCnt,
        "token": token,
      };

  int? get userID => id;

  int get stampCnt => stamp_cnt;

  String get loginID => loginId;

  String get loginpassword => loginPassword;

  String get username => name;

  String get Token => token;
}
