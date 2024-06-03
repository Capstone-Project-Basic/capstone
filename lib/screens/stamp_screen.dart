import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/my_alert_dialog.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/stamp.dart';
import 'package:http/http.dart' as http;

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

Future<StampModel> fetchStamp() async {
  final response =
      await http.get(Uri.parse("http://13.51.143.99:8080/$memberID/stamps"));

  if (response.statusCode == 200) {
    return StampModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load album');
  }
}

class _StampScreenState extends State<StampScreen> {
  late Future<StampModel> futureStamp;

  Future<void> _showMission() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
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
        // onPressed: () => _showMission(),
        onPressed: () {},
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
              const TitleCard(
                title: '(name)의 도장 보관함',
              ),
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
                      FutureBuilder(
                          future: futureStamp,
                          builder: (context, snapshot) {
                            setState(() {
                              showSpinner = true;
                            });
                            if (snapshot.hasData) {
                              showSpinner = false;
                              return Stamp(
                                  successMissionId: snapshot.data!.missionId);
                            } else if (snapshot.hasError) {
                              showSpinner = false;
                              return Stamp(
                                  successMissionId: '${snapshot.error}');
                            }

                            return const Text("Loading...");
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
        color: children,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: const Text('Stamp'),
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
        child: Center(child: Text(title)),
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
