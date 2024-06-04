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
      initialRoute: WelcomeScreen.id,
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
