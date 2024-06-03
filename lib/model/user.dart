import 'dart:convert';

UserModel UserModelJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.loginID,
    required this.loginPassword,
  });

  int id;
  String loginID;
  String loginPassword;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      loginID: json["loginID"],
      loginPassword: json["loginPassword"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "loginID": loginID,
        "loginPassword": loginPassword,
        'id': id,
      };

  String get loginiD => loginID;

  String get loginpassword => loginPassword;
}
