import 'dart:convert';

UserModel UserModelJson(String str) => UserModel.fromJson(json.decode(str));

String UserModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.userEmail,
    required this.userPassword,
  });

  int id;
  String userEmail;
  String userPassword;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userEmail: json["userEmail"],
      userPassword: json["userPassword"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "userEmail": userEmail,
        "userPassword": userPassword,
        'id': id,
      };

  String get useremail => userEmail;

  String get userpassword => userPassword;
}
