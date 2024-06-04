import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/screens/welcome/login_screen.dart';

import 'registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcom_screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Hero(
                      tag: 'logo',
                      child: SizedBox(
                        height: 350,
                        child: Image.asset('assets/images/hiyoko_rounded.png'),
                      ),
                    ),
                    const SizedBox(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 70.0,
                          fontFamily: "Dongle",
                          fontWeight: FontWeight.w900,
                          color: children_light,
                        ),
                        child: Text(
                          '주머니 선생님',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedButton(
                      color: children_dark,
                      title: '시작하기',
                      subTitle: '',
                      buttonFunction: () =>
                          Navigator.pushNamed(context, RegistrationScreen.id),
                    ),
                    RoundedButton(
                      color: const Color.fromRGBO(200, 200, 200, 1),
                      title: '이미 계정이 있나요?',
                      subTitle: ' 로그인',
                      buttonFunction: () =>
                          Navigator.pushNamed(context, LoginScreen.id),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
