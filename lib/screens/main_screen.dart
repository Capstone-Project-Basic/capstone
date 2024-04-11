import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/screens/home_screen.dart';
import 'package:pocekt_teacher/screens/stamp_screen.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentPageIndex = 1;
  List<String> titles = ["Profile", 'Home', 'Stamps'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: NavigationBar(
        backgroundColor: children_dark,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        indicatorColor: children_light,
        selectedIndex: _currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.home,
            ),
            label: '홈 화면',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: '내 도장',
          ),
        ],
      ),
      body: <Widget>[
        const Text('profile'),
        const HomeScreen(),
        const StampScreen(),
      ][_currentPageIndex],
    );
  }
}
