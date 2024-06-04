import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/mission_button.dart';
import '../components/my_alert_dialog.dart';
import '../model/mission.dart';


final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.purple,
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

class MissionPage extends StatelessWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 210, 125, 0.4),
      body: Column(
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
                    color: Colors.white, fontSize: 34.0,
                    fontWeight: FontWeight.bold,),
                ),
              ),
            ),
          ),
        ],
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
  Future<MissionModel> createMission(String missionTitle,
      String missionContent, String grade, String role, BuildContext context) async {
    var response =
    await http.post(Uri.parse("http://13.51.143.99/missions"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "title": missionTitle,
          "loginPassword": missionContent,
          "grade": grade,
          "role": role,
        }));

    String responseString = response.body;
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: "Backend Response", content: response.body);
        },
      );
    }

    return MissionModel(
        id: 9999, missionTitle: 'error email', missionContent: 'error password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션등록', style: TextStyle(fontFamily: "dongle", fontSize: 30),),
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
              decoration: InputDecoration(
                labelText: '미션 제목을 입력하세요',),
            ),
            const SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                content = value;
              },
              decoration: InputDecoration(
                labelText: '미션 내용을 입력하세요',),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MissionGradeButton(grade: '하', color: Colors.orange,
                    buttonFunction: () => grade = "BRONZE",),
                  MissionGradeButton(grade: '중', color: Colors.grey,
                    buttonFunction: () => grade = "SILVER",),
                  MissionGradeButton(grade: '상', color: Colors.yellow,
                    buttonFunction: () => grade = "GOLD",),],
              ),
            ),
            const SizedBox(height: 200.0),
            ElevatedButton(
              onPressed: () async {
                role = 'TEACHER';
                MissionModel missionModel = await createMission(
                    title,
                    content,
                    grade,
                    role,
                    context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MissionEditingPage(
                          missionTitle: title, missionContent: content)),);
              },
              style: commonButtonStyle,
              child: const Text('미션 등록', style: TextStyle( fontFamily: "dongle", fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }
}

class MissionEditingPage extends StatefulWidget {
  final String missionTitle;
  final String missionContent;

  const MissionEditingPage({
    Key? key,
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
        title: const Text('미션 편집', style: TextStyle(fontSize: 30, fontFamily: "dongle"),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.missionTitle,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  widget.missionContent,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('김동글', style: TextStyle(fontSize: 22)),
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
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('김세모', style: TextStyle(fontSize: 22)),
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
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('김네모', style: TextStyle(fontSize: 22)),
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
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
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
