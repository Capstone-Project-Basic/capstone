import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/my_alert_dialog.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/stamp.dart';
import 'package:http/http.dart' as http;
import 'package:pocekt_teacher/model/user.dart';

class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => _StampScreenState();
}

// Future<StampModel> checkStamps(String memberID, BuildContext context) async {
//   var response =
//       await http.post(Uri.parse("http://13.51.143.99:8080/$memberID/stamps"),
//           headers: <String, String>{"Content-Type": "application/json"},
//           body: jsonEncode(<String, String>{
//             "memberID": memberID,
//           }));

//   String responseString = response.body;
//   if (response.statusCode == 200) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext dialogContext) {
//         return MyAlertDialog(title: "Backend Response", content: response.body);
//       },
//     );
//   }

//   return StampModel(
//       id: 9999, missionId: 'error email', memberId: 'error password');
// }
const memberID = 1;
bool showSpinner = false;

Future<UserModel> fetchMission() async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/missions/active"));

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load User');
  }
}

Future<UserModel> fetchUser() async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/members/$memberID"));

  if (response.statusCode == 200) {
    return UserModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load User');
  }
}

Future<List<StampModel>> fetchStamp() async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/$memberID/stamps"));

  // print('Status code: ${response.statusCode}');
  // print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final List body = json.decode(response.body);

    print(body);

    return body.map((e) => StampModel.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load Stamp');
  }
}

class _StampScreenState extends State<StampScreen> {
  late Future<List<StampModel>> futureStamp;
  late Future<UserModel> futureUser;
  late final userName;

  Future<void> _showMission() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          titleTextStyle: kMediumText.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
          title: const Text('오늘의 미션'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'This is a demo alert dialog',
                  style: kSmallText.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'close',
                style: kSmallText.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w300),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    futureStamp = fetchStamp();
    futureUser = fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: children_light,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              FutureBuilder(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return TitleCard(
                        title: snapshot.data!.name,
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    return const TitleCard(
                      title: "There is no data",
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                  ),
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 5,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      FutureBuilder<List<StampModel>>(
                          future: futureStamp,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              //Connecting...
                            } else if (snapshot.hasData) {
                              final stamps = snapshot.data!;
                              return buildStamp(stamps);
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                            return const Text("No Data Available...");
                          }),
                    ],
                  ),
                ),
              ),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              const NameCard(),
              Container(
                width: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildStamp(List<StampModel> stamps) {
  return ListView.builder(
    itemCount: stamps.length,
    itemBuilder: (context, index) {
      final stamp = stamps[index];
      return Stamp(
        successMissionId: stamp.successMissionId.toString(),
      );
    },
  );
}

class Stamp extends StatelessWidget {
  const Stamp({
    super.key,
    required this.successMissionId,
  });

  final String successMissionId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child:
          const Image(image: AssetImage("assets/images/eto_mark10_tori.png")),
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
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(
          '$title의 도장 보관함',
          style: const TextStyle(
            color: Colors.black,
            fontFamily: "Dongle",
            fontSize: 30.0,
          ),
        )),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('(ranking) (name) (number of stamp)'),
            ),
          ],
        ),
      ),
    );
  }
}
