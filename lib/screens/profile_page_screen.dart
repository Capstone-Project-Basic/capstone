import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'package:pocekt_teacher/screens/stamp_screen.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Profile App',
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();

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

  Future<UserModel> fetchUser(memberID) async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/members/$memberID"));

    if (response.statusCode == 200) {
      return UserModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load User data');
    }
  }
}

class ProfilePageState extends State<ProfilePage> {
  late Future<UserModel> futureUser = Future.value(UserModel(
    id: 0,
    loginId: '',
    loginPassword: '',
    name: '',
    stamp_cnt: 0,
  ));

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await currentUser();
    setState(() {
      futureUser = fetchUser(currentmemberID);
      showSpinner = false;
    });
  }

  bool _isEditing = false;
  final TextEditingController _nameController =
      TextEditingController(text: '김동글');
  final TextEditingController _birthController =
      TextEditingController(text: '2010.09.23');
  final TextEditingController _introController =
      TextEditingController(text: '안녕 나는 김동글 이고 축구를 좋아해 친하게 지내자');
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Dongle",
            fontSize: 50.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(234, 210, 129, 0.5),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
          ),
          const SizedBox(width: 20),
        ],
      ),
      backgroundColor: const Color.fromRGBO(234, 210, 129, 0.5),
      body: ProfileWidget(
        isEditing: _isEditing,
        nameController: _nameController,
        birthController: _birthController,
        introController: _introController,
        imageFile: _imageFile,
        onImageTap: _pickImage,
        userName: "koko",
      ),
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }
}

class ProfileWidget extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController birthController;
  final TextEditingController introController;
  final XFile? imageFile;
  final VoidCallback? onImageTap;

  final String userName;

  const ProfileWidget({
    Key? key,
    required this.isEditing,
    required this.nameController,
    required this.birthController,
    required this.introController,
    required this.userName,
    this.imageFile,
    this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          bottom: 50,
          right: 0,
          child: Image(
            image: AssetImage('assets/images/seashell.png'),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onImageTap,
                  child: Container(
                    width: 180,
                    height: 180,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: imageFile != null
                        ? Image.file(
                            File(imageFile!.path),
                            fit: BoxFit.cover,
                          )
                        : const Image(
                            image: AssetImage('assets/images/profile.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.star, size: 50),
                          color: Colors.yellow,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '10개',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.emoji_events, size: 50),
                          color: const Color.fromRGBO(226, 201, 102, 1),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '1위',
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    '이름',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Dongle',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 40),
                isEditing
                    ? Expanded(
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      )
                    : Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nameController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    '생일',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Dongle',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 35),
                isEditing
                    ? Expanded(
                        child: TextField(
                          controller: birthController,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      )
                    : Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          birthController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: const Text(
                    '자기소개',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Dongle',
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 20),
                isEditing
                    ? Expanded(
                        child: TextField(
                          controller: introController,
                          maxLines: null,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      )
                    : Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          introController.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Dongle',
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
