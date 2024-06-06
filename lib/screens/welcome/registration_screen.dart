import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/my_alert_dialog.dart';
import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/resources/AnimatedVisibility.dart';
import 'package:pocekt_teacher/resources/TransitionData.dart';
import 'package:pocekt_teacher/screens/main_screen.dart';
import 'package:pocekt_teacher/screens/welcome/login_screen.dart';

enum Role {
  child,
  teacher,
  none,
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  bool showSpinner = false;
  late String userID;
  late String password;
  late String name;
  late String role;

  Future<UserModel> registerUser(String loginID, String loginPassword,
      String name, String role, BuildContext context) async {
    var response =
        await http.post(Uri.parse("http://13.51.143.99:8080/login/new"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "loginId": loginID,
              "loginPassword": loginPassword,
              "name": name,
              'role': role,
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
        loginId: 'error email',
        loginPassword: 'error password',
        name: 'error name',
        stamp_cnt: 0);
  }

  bool _idIsVisible = true;
  bool _passwordIsVisible = false;
  bool _nameIsVisible = false;
  bool _roleIsVisible = false;
  Role selectedRole = Role.none;

  void selectGender(Role role) {
    role == Role.child
        ? selectedRole = Role.child
        : selectedRole = Role.teacher;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[100],
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: children_light,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: SizedBox(
                          height: 100.0,
                          child:
                              Image.asset('assets/images/hiyoko_rounded.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                    fit: FlexFit.loose,
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimatedVisibility(
                          visible: _idIsVisible,
                          child: Column(
                            children: [
                              TextField(
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 40.0),
                                  onChanged: (value) {
                                    userID = value;
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      _passwordIsVisible = !_passwordIsVisible;
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        FocusScope.of(context).nextFocus();
                                      });
                                    });
                                  },
                                  decoration: kTextFieldDecoration),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                        AnimatedVisibility(
                          visible: _passwordIsVisible,
                          enter: fadeIn(),
                          exit: fadeOut(),
                          child: Column(
                            children: [
                              TextField(
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 40.0),
                                onChanged: (value) {
                                  password = value;
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    _nameIsVisible = !_nameIsVisible;
                                    _idIsVisible = !_idIsVisible;
                                    _passwordIsVisible = !_passwordIsVisible;
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      FocusScope.of(context).nextFocus();
                                    });
                                  });
                                },
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: '비밀번호를 입력하세요'),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                        AnimatedVisibility(
                          visible: _nameIsVisible,
                          enter: fadeIn(),
                          exit: fadeOut(),
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 40.0),
                            onChanged: (value) {
                              name = value;
                            },
                            onEditingComplete: () {
                              setState(() {
                                _nameIsVisible = !_nameIsVisible;
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  _roleIsVisible = !_roleIsVisible;
                                });
                              });
                            },
                            decoration: kTextFieldDecoration.copyWith(
                                hintText: '이름을 입력하세요'),
                          ),
                        ),
                        AnimatedVisibility(
                          visible: _roleIsVisible,
                          enter: fadeIn(),
                          exit: fadeOut(),
                          child: Column(
                            children: [
                              Text(
                                '나는 ...',
                                style: kMediumText.copyWith(color: children),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ReusableCard(
                                    onTapFunction: () {
                                      setState(() {
                                        selectGender(Role.child);
                                        role = 'CHILD';
                                      });
                                    },
                                    background: selectedRole == Role.child
                                        ? children_dark
                                        : Colors.grey,
                                    cardCover: const ReusableCover(
                                      image: AssetImage(
                                          'assets/images/hiyoko.png'),
                                      cardText: '학생입니다',
                                    ),
                                  ),
                                  ReusableCard(
                                    onTapFunction: () {
                                      setState(() {
                                        selectGender(Role.teacher);
                                        role = 'TEACHER';
                                      });
                                    },
                                    background: selectedRole == Role.teacher
                                        ? children_dark
                                        : Colors.grey,
                                    cardCover: const ReusableCover(
                                      image: AssetImage(
                                          'assets/images/niwatori.png'),
                                      cardText: '선생님입니다',
                                    ),
                                  ),
                                ],
                              ),
                              RoundedButton(
                                color: children_dark,
                                title: '회원가입',
                                subTitle: '',
                                buttonFunction: () async {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  String loginID = userID;
                                  String loginPassword = password;
                                  UserModel userModel = await registerUser(
                                      loginID,
                                      loginPassword,
                                      name,
                                      role,
                                      context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const LoginScreen()));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 60.0,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.background,
    required this.cardCover,
    required this.onTapFunction,
  });

  final Color background;
  final Widget cardCover;
  final VoidCallback onTapFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapFunction,
      child: Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(25.0),
        width: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: background,
        ),
        child: cardCover,
      ),
    );
  }
}

class ReusableCover extends StatelessWidget {
  const ReusableCover({super.key, required this.image, required this.cardText});

  final AssetImage image;
  final String cardText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: image,
          height: 100.0,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          cardText,
          style: kSmallText,
        ),
      ],
    );
  }
}
