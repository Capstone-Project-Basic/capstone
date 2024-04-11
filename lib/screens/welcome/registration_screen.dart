import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/screens/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  bool showSpinner = false;
  late String email;
  late String password;

  Future<UserModel> registerUser(
      String userEmail, String userPassword, BuildContext context) async {
    var response =
        await http.post(Uri.parse("http://localhost:8080/members/new"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "userEmail": userEmail,
              "userPassword": userPassword,
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
        id: 9999, userEmail: 'error email', userPassword: 'error password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: children_light,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 150.0,
                    ),
                    Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: 250.0,
                        child: Image.asset('assets/images/hiyoko_rounded.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: kTextFieldDecoration,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: '비밀번호를 입력하세요'),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    color: children_dark,
                    title: '회원가입',
                    subTitle: '',
                    buttonFunction: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      String userEmail = email;
                      String userPassword = password;
                      UserModel userModel =
                          await registerUser(userEmail, userPassword, context);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             const MainScreen()));
                      // Add some function to create account
                    },
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class MyAlertDialog extends StatelessWidget {
  const MyAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
  });

  final String title;
  final String content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: actions,
        content: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ));
  }
}
