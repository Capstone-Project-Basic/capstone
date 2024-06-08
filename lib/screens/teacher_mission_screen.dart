import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/screens/stamp_screen.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart';
import '../components/mission_button.dart';
import '../components/my_alert_dialog.dart';
import '../model/mission.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
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
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/members/$memberId"));

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
      "role": "TEACHER", // 회원의 역할 사용
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
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/missions/active"));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse
        .map((mission) => MissionModel.fromJson(mission))
        .toList();
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
  Future<List<UserModel>> fetchMembers() async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/members"));

    if (response.statusCode == 200) {
      final List body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Stamp data');
    }
  }

  Future<MissionModel> passMission(
      String studentMemberId, String missionId, String teacherMemberId) async {
    var response = await http.post(
        Uri.parse(
            "http://13.51.143.99:8080/$teacherMemberId/missions/$missionId"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "missionId": missionId,
          "memberId": studentMemberId,
        }));
    print("responseStatusCode : ${response.statusCode}");
    print("response.body : ${response.body}");

    if (response.statusCode == 200) {
      print("Success to pass mission");
    } else {
      print("Failed to pass mission");
    }
    return MissionModel(
      title: '',
      content: '',
      grade: '',
      missionId: 0,
      activeStatus: true,
    );
  }

  Future<MissionModel> giveStamp(String memberId, String missionId) async {
    var response =
        await http.post(Uri.parse("http://13.51.143.99:8080/$memberId/stamps"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "memberId": memberId,
              "missionId": missionId,
            }));
    print("responseStatusCode : ${response.statusCode}");
    print("response.body : ${response.body}");

    if (response.statusCode == 200) {
      print("Success to pass mission");
    } else {
      print("Failed to pass mission");
    }
    return MissionModel(
      title: '',
      content: '',
      grade: '',
      missionId: 0,
      activeStatus: true,
    );
  }

  Future<List<MissionModel>> fetchMissions() async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/missions/active"));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((mission) => MissionModel.fromJson(mission))
          .toList();
    } else {
      throw Exception('미션 로드 실패');
    }
  }

  late Future<List<MissionModel>> futureMission = Future.value([]);
  late Future<List<UserModel>> futureMembers = Future.value([]);
  int missionID = 0;
  String missionContent = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeMissions();
  }

  Future<void> _initializeData() async {
    setState(() {
      futureMembers = fetchMembers();
      futureMission = fetchMissions();
    });
  }

  Future<void> _initializeMissions() async {
    try {
      final missions = await fetchMissions();
      if (missions.isNotEmpty) {
        setState(() {
          missionID = missions.first.missionId;
          missionContent = missions.first.missioncontent;
          print("missionID : $missionID");
        });
      } else {
        print('No missions found');
      }
    } catch (e) {
      print('Failed to fetch missions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (missionID == 0) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
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
                      MaterialPageRoute(
                          builder: (context) =>
                              const MissionRegistrationPage()),
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
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TitleCard(
                  title: missionContent,
                ),
                FutureBuilder<List<UserModel>>(
                  future: futureMembers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //Connecting...
                    } else if (snapshot.hasData) {
                      final users = snapshot.data!;
                      users.sort((a, b) => a.stampCnt.compareTo(b.stampCnt));
                      print(users);
                      return buildRanking(users, passMission, giveStamp,
                          missionID.toString(), currentmemberID.toString());
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    return const Text("No Data Available...");
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await completeMission(missionID);
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
                  child: const Text('미션 종료',
                      style: TextStyle(
                          fontFamily: "dongle",
                          fontSize: 25,
                          color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // active 미션 리스트
    // return
  }
}

class MissionRegistrationPage extends StatefulWidget {
  const MissionRegistrationPage({super.key});

  @override
  State<MissionRegistrationPage> createState() =>
      _MissionRegistrationPageState();
}

late String title;
late String content;
late String grade;
late String role;

class _MissionRegistrationPageState extends State<MissionRegistrationPage> {
  Future<MissionModel?> createMission(
      String missionTitle,
      String missionContent,
      String grade,
      String role,
      BuildContext context) async {
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
        titleStyle: const TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold), // 타이틀 폰트 크기 설정
        msgStyle: const TextStyle(fontSize: 20.0), // 메시지 폰트 크기 설정
      );

      Future.delayed(const Duration(seconds: 2), () {
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
              title: "Error",
              content: "Failed to register mission: ${response.body}");
        },
      );
      return null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '아이들을 위한 미션을 제안해보세요 !',
                  style: TextStyle(
                      fontFamily: "dongle", fontSize: 25, color: Colors.black),
                ),
                const SizedBox(height: 10.0),
                const Image(
                  image: AssetImage('assets/images/teacher.png'),
                  width: 150.0,
                ),
                const SizedBox(height: 50.0),
                // const Text(
                //   '미션 제목을 입력하세요',
                //   style: TextStyle(fontSize: 40.0),
                // ),
                // const SizedBox(height: 10.0),
                // TextField(
                //   onChanged: (value) {
                //     title = value;
                //   },
                //   decoration: kTextFieldDecoration.copyWith(hintText: ''),
                //   style: const TextStyle(fontSize: 30.0),
                // ),
                const SizedBox(height: 20.0),
                const Text(
                  '미션 내용을 입력하세요',
                  style: TextStyle(fontSize: 40.0),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    content = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: ''),
                  style: const TextStyle(fontSize: 30.0),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    role = 'TEACHER';
                    await createMission(
                        'missiontitle', content, 'BRONZE', role, context);
                  },
                  style: commonButtonStyle,
                  child: const Text(
                    '미션 등록',
                    style: TextStyle(
                        fontFamily: "dongle",
                        fontSize: 25,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MissionEditingPage extends StatefulWidget {
  // 미션 편집 페이지
  final int missionId;
  final String missionTitle;
  final String missionContent;

  const MissionEditingPage({
    Key? key,
    required this.missionId,
    required this.missionId,
    required this.missionTitle,
    required this.missionContent,
  }) : super(key: key);

  @override
  _MissionEditingPageState createState() => _MissionEditingPageState();
}

class _MissionEditingPageState extends State<MissionEditingPage> {
  Future<List<UserModel>> fetchMembers() async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/members"));

    if (response.statusCode == 200) {
      final List body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Stamp data');
    }
  }

  Future<MissionModel> passMission(
      String studentMemberId, String missionId, String teacherMemberId) async {
    var response = await http.post(
        Uri.parse(
            "http://13.51.143.99:8080/$teacherMemberId/missions/$missionId"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "missionId": missionId,
          "memberId": studentMemberId,
        }));
    print("responseStatusCode : ${response.statusCode}");
    print("response.body : ${response.body}");

    if (response.statusCode == 200) {
      print("Success to pass mission");
    } else {
      print("Failed to pass mission");
    }
    return MissionModel(
      title: '',
      content: '',
      grade: '',
      missionId: 0,
      activeStatus: true,
    );
  }

  late UserModel loginUser;

  Future<MissionModel> giveStamp(String memberId, String missionId) async {
    var response =
        await http.post(Uri.parse("http://13.51.143.99:8080/$memberId/stamps"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "memberId": memberId,
              "missionId": missionId,
            }));
    print("responseStatusCode : ${response.statusCode}");
    print("response.body : ${response.body}");

    if (response.statusCode == 200) {
      print("Success to pass mission");
    } else {
      print("Failed to pass mission");
    }
    return MissionModel(
      title: '',
      content: '',
      grade: '',
      missionId: 0,
      activeStatus: true,
    );
  }

  Future<UserModel> currentUser() async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(MyCookieManager.instance.cookieJar));

    final response = await dio.get("http://13.51.143.99:8080");

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.data}');

    if (response.statusCode == 200) {
      loginUser = UserModel.fromJson(response.data as Map<String, dynamic>);
      currentmemberID = loginUser.id;
      print('loginUser: $loginUser');
      print('currentmemberID: $currentmemberID');
      return loginUser;
    } else {
      throw Exception('Failed to load currentUser');
    }
  }

  Future<List<MissionModel>> fetchMissions() async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/missions/active"));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((mission) => MissionModel.fromJson(mission))
          .toList();
    } else {
      throw Exception('미션 로드 실패');
    }
  }

  late Future<List<MissionModel>> futureMission = Future.value([]);
  late Future<List<UserModel>> futureMembers = Future.value([]);
  int missionID = 0;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _initializeMissions();
  }

  Future<void> _initializeData() async {
    setState(() {
      futureMembers = fetchMembers();
      futureMission = fetchMissions();
    });
  }

  Future<void> _initializeMissions() async {
    try {
      final missions = await fetchMissions();
      if (missions.isNotEmpty) {
        setState(() {
          missionID = missions.first.missionId;
          print("missionID : $missionID");
        });
      } else {
        print('No missions found');
      }
    } catch (e) {
      print('Failed to fetch missions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TitleCard(
                title: widget.missionContent,
              ),
              FutureBuilder<List<UserModel>>(
                future: futureMembers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //Connecting...
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    users.sort((a, b) => a.stampCnt.compareTo(b.stampCnt));
                    print(users);
                    return buildRanking(users, passMission, giveStamp,
                        missionID.toString(), currentmemberID.toString());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return const Text("No Data Available...");
                },
              ),
              const SizedBox(
                height: 15.0,
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
                child: const Text('미션 종료',
                    style: TextStyle(
                        fontFamily: "dongle",
                        fontSize: 25,
                        color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildRanking(List<UserModel> users, Function function,
    Function function2, String missionID, String teacherID) {
  return Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final rank = (index + 1).toString();
        Color color = Colors.grey;
        Color bgColor = Colors.grey.shade200;
        IconData icon = FontAwesomeIcons.medal;

        switch (rank) {
          case '1':
            color = const Color.fromRGBO(255, 213, 79, 1);
            icon = FontAwesomeIcons.crown;
            break;
          case '2':
            color = const Color.fromRGBO(255, 213, 79, 1);
            break;
          case '3':
            color = const Color.fromRGBO(255, 213, 79, 1);
            break;
        }

        return GestureDetector(
          onTap: () {
            function(
              user.id.toString(),
              missionID,
              teacherID,
            );
            function2(user.id.toString(), missionID);
          },
          child: NameCard(
            ranking: rank,
            name: user.name,
            stamps: user.stamp_cnt,
            color: color,
            icon: icon,
            backgroundColor: bgColor,
          ),
        );
      },
    ),
  );
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: children_light,
          border: Border.symmetric(
              horizontal: BorderSide(
            color: children_dark,
            width: 2,
          ))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Dongle",
            fontSize: 35.0,
          ),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  NameCard({
    super.key,
    required this.ranking,
    required this.name,
    required this.stamps,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });

  String ranking;
  String name;
  int stamps;
  Color color;
  Color backgroundColor;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: const Border(
              bottom: BorderSide(
            color: children,
            width: 1,
          ))
          // borderRadius: BorderRadius.circular(8),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    '$ranking위',
                    style: kSmallText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20.0),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/hiyoko.png'),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    name,
                    style: kSmallText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '$stamps개의 도장',
                    style: kSmallText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20.0),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  FaIcon(
                    icon,
                    color: color,
                    shadows: const <Shadow>[
                      Shadow(color: Colors.black, blurRadius: 15.0)
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
