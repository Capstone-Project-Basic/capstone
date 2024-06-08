import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/screens/home_screen.dart';
import 'package:pocekt_teacher/screens/stamp_screen.dart';
import 'package:pocekt_teacher/screens/profile_page_screen.dart';
import 'package:pocekt_teacher/screens/teacher_mission_screen.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart';

class MainScreen extends StatefulWidget {
  static String id = 'main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late UserModel loginUser;
  bool teacher = false;
  bool isLoading = true;

  Future<UserModel> currentUser() async {
    var dio = Dio();
    dio.interceptors.add(CookieManager(MyCookieManager.instance.cookieJar));

    final response = await dio.get("http://13.51.143.99:8080");

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.data}');

    if (response.statusCode == 200) {
      loginUser = UserModel.fromJson(response.data as Map<String, dynamic>);
      currentmemberID = loginUser.id;
      print('loginUser: $loginUser');
      print('currentmemberID: $currentmemberID');
      return loginUser;
    } else {
      throw Exception('Failed to load currentUser');
    }
  }

  int _currentPageIndex = 1;
  List<String> titles = ["Profile", 'Home', 'Stamps'];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await currentUser();
    setState(() {
      if (loginUser.role == "TEACHER") {
        titles.add('teacher');
        teacher = true;
      }
      isLoading = false; // 데이터 로드가 완료되었음을 나타냅니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      ); // 로딩 중일 때는 로딩 스피너를 표시합니다.
    }

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
        destinations: _buildNavigationDestinations(),
      ),
      body: <Widget>[
        const ProfileApp(),
        const HomeScreen(),
        const StampScreen(),
        if (teacher) const MissionPage(),
      ][_currentPageIndex],
    );
  }

  List<NavigationDestination> _buildNavigationDestinations() {
    List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Icons.person),
        label: '내 정보',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.home,
        ),
        label: '홈 화면',
      ),
      const NavigationDestination(
        icon: Icon(Icons.menu_book),
        label: '내 도장',
      ),
    ];

    if (teacher) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.telegram),
          label: '선생님 도장',
        ),
      );
    }

    return destinations;
  }
}
