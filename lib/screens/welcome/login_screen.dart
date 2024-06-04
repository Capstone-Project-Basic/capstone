import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/my_alert_dialog.dart';
import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:pocekt_teacher/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  late String loginID;
  late String loginPassword;

  Future<UserModel> loginUser(
      String loginID, String loginPassword, BuildContext context) async {
    var response = await http.post(Uri.parse("http://13.51.143.99:8080/login"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          "loginId": loginID,
          "loginPassword": loginPassword,
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

    return UserModel(
        id: 9999,
        loginID: 'error email',
        loginPassword: 'error password',
        name: 'error name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: children_dark,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 100.0,
                    ),
                    Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: 250.0,
                        child: Image.asset('assets/images/hiyoko_rounded.png'),
                      ),
                    ),
                    const SizedBox(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 40.0,
                          fontFamily: "Dongle",
                          fontWeight: FontWeight.w900,
                          color: children_light,
                        ),
                        child: Text(
                          '어서오세요! 기다리고 있었어요',
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: const TextStyle(fontSize: 40.0),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        loginID = value;
                      },
                      decoration: kTextFieldDecoration,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 40.0),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        loginPassword = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: '비밀번호를 입력하세요'),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                        color: children,
                        title: '로그인',
                        subTitle: '',
                        buttonFunction: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          //Add some function to login user
                          UserModel userModel =
                              await loginUser(loginID, loginPassword, context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const MainScreen()));
                        }),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
