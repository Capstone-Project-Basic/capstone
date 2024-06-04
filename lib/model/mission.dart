import 'dart:convert';

MissionModel MissionModelJson(String str) => MissionModel.fromJson(json.decode(str));

String MissionModelToJson(MissionModel data) => json.encode(data.toJson());

class MissionModel {
  MissionModel({
    required this.id,
    required this.missionTitle,
    required this.missionContent,
  });

  int id;
  String missionTitle;
  String missionContent;

  factory MissionModel.fromJson(Map<String, dynamic> json) => MissionModel(
      missionTitle: json["missionTitle"],
      missionContent: json["missionContent"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
    "missionTitle": missionTitle,
    "missionContent": missionContent,
    'id': id,
  };

  String get missiontitle => missionTitle;

  String get missioncontent => missionContent;
}
