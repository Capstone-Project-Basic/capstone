import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/mission.dart';
import 'package:pocekt_teacher/model/stamp.dart';
import 'package:http/http.dart' as http;
import 'package:pocekt_teacher/model/user.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => _StampScreenState();
}

late UserModel loginUser;
int? currentmemberID = 1;
bool showSpinner = true;

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

Future<UserModel> fetchUser(memberID) async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/members/$memberID"));

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load User data');
  }
}

Future<List<StampModel>> fetchStamp(memberID) async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/$memberID/stamps"));

  if (response.statusCode == 200) {
    final List body = json.decode(response.body);
    return body.map((e) => StampModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load Stamp data');
  }
}

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

class _StampScreenState extends State<StampScreen> {
  late Future<List<StampModel>> futureStamp = Future.value([]);
  late Future<List<UserModel>> futureMembers = Future.value([]);
  late Future<UserModel> futureUser = Future.value(UserModel(
    id: 0,
    loginId: '',
    loginPassword: '',
    name: '',
    stamp_cnt: 0,
    token: '',
    image_path: '',
    role: '',
  ));
  late Future<List<MissionModel>> futureMission = Future.value([]);
  String missionContent = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await currentUser();
    try {
      final missions = await fetchMissions();
      if (missions.isNotEmpty) {
        setState(() {
          missionContent = missions.first.missioncontent;
        });
      } else {
        print('No missions found');
      }
    } catch (e) {
      print('Failed to fetch missions: $e');
    }
    setState(() {
      futureStamp = fetchStamp(currentmemberID);
      futureUser = fetchUser(currentmemberID);
      futureMembers = fetchMembers();
      showSpinner = false;
    });
  }

  Future<void> _showMission() async {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: missionContent,
      msgStyle: const TextStyle(
        fontSize: 25.0,
      ),
      msgAlign: TextAlign.center,
      title: '오늘의 미션!',
      titleStyle: const TextStyle(
        fontSize: 40.0,
      ),
      lottieBuilder: Lottie.asset(
        'assets/lottie/flag.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    String userName = loginUser.name;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          elevation: 0,
          onPressed: () => _showMission(),
          child: const Image(
            image: AssetImage('assets/images/teacher.png'),
          ),
        ),
        backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            children: [
              FutureBuilder(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      showSpinner = true;
                    } else if (snapshot.hasData) {
                      userName = snapshot.data!.name;
                      print("$userName의 멤버 아이디 : ${snapshot.data!.id}");
                      return TitleCard(
                        title: '$userName의 도장 보관함',
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    return const TitleCard(
                      title: "There is no data",
                    );
                  }),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(238, 238, 238, 1),
                ),
                // child: FutureBuilder<List<StampModel>>(
                //     future: futureStamp,
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState ==
                //           ConnectionState.waiting) {
                //         //Connecting...
                //       } else if (snapshot.hasData) {
                //         final stamps = snapshot.data!;
                //         final stampLength = loginUser.stamp_cnt;
                //         return buildStamp(stamps, stampLength);
                //       } else if (snapshot.hasError) {
                //         print(snapshot.error);
                //       }
                //       return const Text("No Data Available...");
                //     }),
              ),
              buildStampsRow(loginUser.stamp_cnt),
              const TitleCard(title: '도장 순위'),
              FutureBuilder<List<UserModel>>(
                future: futureMembers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //Connecting...
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    users.sort((a, b) => a.stampCnt.compareTo(b.stampCnt));
                    final usersReverse = users.reversed.toList();
                    return buildRanking(usersReverse, userName);
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return const Text("No Data Available...");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildStampsRow(int count) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 20.0),
    child: Row(
      children: List.generate(count, (index) => const Stamp()),
    ),
  );
}

Widget buildStamp(List<StampModel> stamps, int length) {
  print("length $length");
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: length,
    itemBuilder: (context, index) {
      print("created!");
      return const Stamp();
    },
  );
}

Widget buildRanking(List<UserModel> users, String userName) {
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
        if (user.name == userName) {
          bgColor = children_light;
        }

        return NameCard(
          ranking: rank,
          name: user.name,
          stamps: user.stamp_cnt,
          color: color,
          icon: icon,
          backgroundColor: bgColor,
        );
      },
    ),
  );
}

class Stamp extends StatelessWidget {
  const Stamp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Image(
        image: AssetImage("assets/images/eto_mark10_tori.png"),
        width: 50.0,
      ),
    );
  }
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
      height: 50,
      width: double.infinity,
      decoration: const BoxDecoration(
          color: children_light,
          border: Border.symmetric(
              horizontal: BorderSide(
            color: children_dark,
            width: 2,
          ))),
      child: Center(
          child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: "Dongle",
          fontSize: 35.0,
        ),
      )),
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
