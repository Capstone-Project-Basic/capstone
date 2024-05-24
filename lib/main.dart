import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/screens/welcome/login_screen.dart';
import 'package:pocekt_teacher/screens/welcome/registration_screen.dart';
import 'package:pocekt_teacher/screens/welcome/welcome_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const PocketTeacher());
}

class PocketTeacher extends StatelessWidget {
  const PocketTeacher({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Teacher',
      theme: ThemeData(
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: children_dark,
          labelTextStyle: MaterialStatePropertyAll(TextStyle(fontSize: 20.0)),
        ),
        fontFamily: 'Dongle',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MainScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        MainScreen.id: (context) => const MainScreen(),
        // StampScreen.id
      },
    );
  }
}
