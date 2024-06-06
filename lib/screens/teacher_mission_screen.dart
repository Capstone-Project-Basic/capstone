import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../components/mission_button.dart';
import '../components/my_alert_dialog.dart';
import '../model/mission.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';

final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.purple,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

Future<Map<String, dynamic>> fetchMemberInfo(int memberId) async {
  final response = await http.get(Uri.parse("http://13.51.143.99:8080/members/$memberId"));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('회원 정보 로드 실패');
  }
}

Future<void> completeMission(int missionId) async {
  final response = await http.patch(
    Uri.parse("http://13.51.143.99:8080/missions/$missionId/unactive"),
    headers: <String, String>{
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, dynamic>{
      "activeStatus": false, // 미션을 비활성화로 표시
      "role": "TEACHER",    // 회원의 역할 사용
    }),
  );

  print("responseStatusCode ${response.statusCode}");
  print("responseBody ${response.body}");
  if (response.statusCode == 200) {
    print("Mission completed successfully");


  } else {
    throw Exception('미션 완료 실패');
  }
}
Future<List<MissionModel>> fetchMissions() async {
  final response = await http.get(Uri.parse("http://13.51.143.99:8080/missions/active"));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((mission) => MissionModel.fromJson(mission)).toList();
  } else {
    throw Exception('미션 로드 실패');
  }
}
class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  late Future<List<MissionModel>> futureMission;




  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  Future<void> _loadMissions() async {
    futureMission = fetchMissions();
  }


  @override
  Widget build(BuildContext context) { // active 미션 리스트
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 210, 125, 0.4),
      body: FutureBuilder<List<MissionModel>>(
        future: futureMission,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].content),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () async {
                      print("missionID: ${snapshot.data![index].missionId}");
                      await completeMission(snapshot.data![index].missionId);
                    },
                  ),
                );
              },
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    '현재 등록된 미션이 없습니다',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MissionRegistrationPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(234, 210, 129, 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Text(
                        'Mission',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class MissionRegistrationPage extends StatefulWidget {
  @override
  State<MissionRegistrationPage> createState() => _MissionRegistrationPageState();
}

late String title;
late String content;
late String grade;
late String role;

class _MissionRegistrationPageState extends State<MissionRegistrationPage> {
  Future<MissionModel?> createMission(String missionTitle,
      String missionContent, String grade, String role, BuildContext context) async {
    var response = await http.post(
      Uri.parse("http://13.51.143.99:8080/missions"),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "title": missionTitle,
        "content": missionContent,
        "grade": grade,
        "role": role,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      int missionId = responseData['missionId'] ?? 1;
      print("Mission registered with ID: $missionId"); // 등록된 미션 ID 출력

      Dialogs.materialDialog(
        color: Colors.white,
        msg: '미션이 등록되었습니다!',
        title: '등록 성공',
        lottieBuilder: Lottie.asset(
          'assets/lottie/mission.json',
          fit: BoxFit.contain,
        ),
        context: context,
        titleStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold), // 타이틀 폰트 크기 설정
        msgStyle: TextStyle(fontSize: 20.0), // 메시지 폰트 크기 설정
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MissionEditingPage(
              missionId: missionId,
              missionTitle: missionTitle,
              missionContent: missionContent,
            ),
          ),
        );
      });

      return MissionModel.fromJson(responseData);
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: "Error", content: "Failed to register mission: ${response.body}");
        },
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션등록', style: TextStyle(fontFamily: "dongle", fontSize: 30)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                title = value;
              },
              decoration: const InputDecoration(
                labelText: '미션 제목을 입력하세요',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                content = value;
              },
              decoration: const InputDecoration(
                labelText: '미션 내용을 입력하세요',
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MissionGradeButton(
                    grade: '하',
                    color: Colors.orange,
                    buttonFunction: () => setState(() => grade = "BRONZE"),
                  ),
                  MissionGradeButton(
                    grade: '중',
                    color: Colors.grey,
                    buttonFunction: () => setState(() => grade = "SILVER"),
                  ),
                  MissionGradeButton(
                    grade: '상',
                    color: Colors.yellow,
                    buttonFunction: () => setState(() => grade = "GOLD"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200.0),
            ElevatedButton(
              onPressed: () async {
                role = 'TEACHER';
                await createMission(title, content, grade, role, context);
              },
              style: commonButtonStyle,
              child: const Text(
                '미션 등록',
                style: TextStyle(fontFamily: "dongle", fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MissionEditingPage extends StatefulWidget { // 미션 편집 페이지
  final int missionId;
  final String missionTitle;
  final String missionContent;

  const MissionEditingPage({
    Key? key,
    required this.missionId,
    required this.missionTitle,
    required this.missionContent,
  }) : super(key: key);

  @override
  _MissionEditingPageState createState() => _MissionEditingPageState();
}

class _MissionEditingPageState extends State<MissionEditingPage> {
  bool switchValue1 = false;
  bool switchValue2 = false;
  bool switchValue3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션 편집', style: TextStyle(fontSize: 30, fontFamily: "dongle")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.missionTitle,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.missionContent,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('김동글', style: TextStyle(fontSize: 22)),
                  Switch(
                    value: switchValue1,
                    onChanged: (value) {
                      setState(() {
                        switchValue1 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('김세모', style: TextStyle(fontSize: 22)),
                  Switch(
                    value: switchValue2,
                    onChanged: (value) {
                      setState(() {
                        switchValue2 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('김네모', style: TextStyle(fontSize: 22)),
                  Switch(
                    value: switchValue3,
                    onChanged: (value) {
                      setState(() {
                        switchValue3 = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: commonButtonStyle,
                  child: const Text('편집', style: TextStyle(fontFamily: "dongle", fontSize: 25)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await completeMission(1);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } catch (e) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext dialogContext) {
                          return MyAlertDialog(
                              title: "Error", content: "미션 완료 실패: $e");
                        },
                      );
                    }
                  },
                  style: commonButtonStyle,
                  child: const Text('완료하기', style: TextStyle(fontFamily: "dongle", fontSize: 25)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
