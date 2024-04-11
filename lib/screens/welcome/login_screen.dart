import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: children_dark,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      style: const TextStyle(fontSize: 40.0),
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
                      style: const TextStyle(fontSize: 40.0),
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
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
                        }),
                    const SizedBox(
                      height: 50.0,
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
