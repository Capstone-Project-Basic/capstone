import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pocekt_teacher/components/my_alert_dialog.dart';
import 'package:pocekt_teacher/components/rounded_button.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/screens/main_screen.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart'; // MyCookieManager import

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
  late Dio dio;

  @override
  void initState() {
    dio = Dio();
    dio.interceptors.add(CookieManager(MyCookieManager.instance.cookieJar));
    super.initState();
  }

  Future<UserModel> loginUser(
      String loginID, String loginPassword, BuildContext context) async {
    print("Attempting login with ID: $loginID and Password: $loginPassword");

    try {
      var response = await dio.post(
        "http://13.51.143.99:8080/login",
        data: {
          "loginId": loginID,
          "loginPassword": loginPassword,
        },
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );

      // Cookies after login
      List<Cookie> cookies = await MyCookieManager.instance.cookieJar
          .loadForRequest(Uri.parse("http://13.51.143.99:8080/"));
      print(
          "Received Cookies: ${cookies.map((cookie) => '${cookie.name}: ${cookie.value}').join(', ')}");

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MainScreen()));
      } else {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return MyAlertDialog(
                title: "Failed login", content: response.toString());
          },
        );
        setState(() {
          showSpinner = false;
        });
      }
    } catch (e) {
      print("Error during communication: $e");
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: "Network Error",
              content: "Error during communication: $e");
        },
      );
      setState(() {
        showSpinner = false;
      });
    }

    return UserModel(
        id: 9999,
        loginId: 'error email',
        loginPassword: 'error password',
        name: 'error name',
        stamp_cnt: 0);
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
