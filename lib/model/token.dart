import 'dart:convert';

Token TokenJson(String str) => Token.fromJson(json.decode(str));

String TokenToJson(Token data) => json.encode(data.toJson());

class Token {
  Token({
    this.id,
    required this.token,
  });

  int? id;
  String token;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        token: json["token"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        'id': id,
      };

  String get userToken => token;
}
