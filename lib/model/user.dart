import 'dart:convert';

UserModel UserModelJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    required this.loginID,
    required this.loginPassword,
    required this.name,
  });

  int? id;
  String loginID;
  String loginPassword;
  String name;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      loginID: json["loginID"] ?? "",
      loginPassword: json["loginPassword"] ?? "",
      name: json["name"] ?? "",
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "loginID": loginID,
        "loginPassword": loginPassword,
        "name": name,
        'id': id,
      };

  String get loginiD => loginID;

  String get loginpassword => loginPassword;

  String get username => name;
}
