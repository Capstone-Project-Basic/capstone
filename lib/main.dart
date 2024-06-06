import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:pocekt_teacher/api/firebase_api.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/highfive.dart';
import 'package:pocekt_teacher/screens/notification_screen.dart';
import 'package:pocekt_teacher/screens/welcome/login_screen.dart';
import 'package:pocekt_teacher/screens/welcome/registration_screen.dart';
import 'package:pocekt_teacher/screens/welcome/welcome_screen.dart';
import 'screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final dio = Dio();
  // final cookieJar = CookieJar();
  // dio.interceptors.add(CookieManager(cookieJar));
  // await dio.get('https://pub.dev/');
  // // Print cookies
  // print(await cookieJar.loadForRequest(Uri.parse('https://pub.dev/')));
  // // Another request with the cookie.
  // await dio.get("https://pub.dev/");

  runApp(const PocketTeacher());
}

class PocketTeacher extends StatefulWidget {
  const PocketTeacher({super.key});

  @override
  State<PocketTeacher> createState() => _PocketTeacherState();
}

class _PocketTeacherState extends State<PocketTeacher> {
  @override
  void initState() {
    FirebaseApi().initNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Teacher',
      theme: ThemeData(
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: children_dark,
          labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 20.0)),
        ),
        fontFamily: 'Dongle',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MainScreen.id,
      navigatorKey: navigatorKey,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        MainScreen.id: (context) => const MainScreen(),
        NotificationScreen.id: (context) => const NotificationScreen(),
        Highfive.id: (context) => const Highfive(),
        // StampScreen.id
      },
    );
  }
}
