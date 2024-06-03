import 'dart:convert';

StampModel StampModelJson(String str) => StampModel.fromJson(json.decode(str));

String StampModelToJson(StampModel data) => json.encode(data.toJson());

class StampModel {
  StampModel({
    required this.id,
    required this.missionId,
    required this.memberId,
  });

  int id;
  String missionId;
  String memberId;

  factory StampModel.fromJson(Map<String, dynamic> json) => StampModel(
      missionId: json["stampEmail"],
      memberId: json["stampPassword"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "stampEmail": missionId,
        "stampPassword": memberId,
        'id': id,
      };

  String get missionid => missionId;

  String get memberid => memberId;
}
