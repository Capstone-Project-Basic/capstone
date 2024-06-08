import 'dart:convert';

MissionModel missionModelFromJson(String str) =>
    MissionModel.fromJson(json.decode(str));

String missionModelToJson(MissionModel data) => json.encode(data.toJson());
String missionModelToJson(MissionModel data) => json.encode(data.toJson());

class MissionModel {
  MissionModel({
    required this.missionId,
    required this.activeStatus,
    required this.content,
    required this.grade,
    required this.title,
    required this.missionId,
    required this.activeStatus,
    required this.content,
    required this.grade,
    required this.title,
  });

  int missionId;
  bool activeStatus;
  String content;
  String grade;
  String title;
  int missionId;
  bool activeStatus;
  String content;
  String grade;
  String title;

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
        missionId: json["missionId"] ?? 0,
        activeStatus: json["active_status"] ?? false,
        content: json["content"] ?? '',
        grade: json["grade"] ?? '',
        title: json["title"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "missionId": missionId,
        "active_status": activeStatus,
        "content": content,
        "grade": grade,
        "title": title,
      };

  int get missionid => missionId;

  String get missioncontent => content;

  String get missiontitle => title;

  bool get activestatus => activeStatus;
}
