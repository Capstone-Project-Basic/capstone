import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/screens/page.dart';
import 'package:pocekt_teacher/screens/school_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();

  final pageList = [
    const SchoolPage(
      buttonImage: Image(image: AssetImage('assets/images/school.png')),
    ),
    NoticeListScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sky_light,
      body: PageView(
        controller: _pageController,
        children: const [
          SchoolPage(
            buttonImage: Image(image: AssetImage('assets/images/school.png')),
          ),
          SchoolPage(
            buttonImage: Image(image: AssetImage('assets/images/library.png')),
          ),
        ],
      ),
    );
  }
}