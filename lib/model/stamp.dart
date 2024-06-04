import 'dart:convert';

StampModel StampModelJson(String str) => StampModel.fromJson(json.decode(str));

String StampModelToJson(StampModel data) => json.encode(data.toJson());

class StampModel {
  StampModel({
    required this.id,
    required this.successMissionId,
    required this.memberId,
  });

  int id;
  int successMissionId;
  int memberId;

  factory StampModel.fromJson(Map<String, dynamic> json) => StampModel(
      successMissionId: json["successMissionId"] ?? "",
      memberId: json["memberId"] ?? "",
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "successMissionId": successMissionId,
        "memberId": memberId,
        'id': id,
      };

  int get successMissionid => successMissionId;

  int get memberid => memberId;
}
