import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Profile App',
      home:  ProfilePage(),
    );
  }
}
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
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
        actions: const [
          SizedBox(width: 20),
          Text(
            '설정',
            style: TextStyle(
              color: Colors.white,
              fontSize: 35.0,
              fontFamily: "Dongle",
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      backgroundColor: const Color.fromRGBO(234, 210, 129, 0.5),
      body: const ProfileWidget(),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  XFile? file;

  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          file = image;
          print(file);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          bottom: 50,
          right: 0,
          child: Image(image: AssetImage('assets/images/seashell.png'),
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
                GestureDetector( onTap:() {
                  _pickImage();
                },
                child: Container(
                  width: 180,
                  height: 180,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Image(image: AssetImage('assets/images/profile.png'),
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
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '김동글',
                    style: TextStyle(
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
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '2010.09.23',
                    style: TextStyle(
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
                  margin: const EdgeInsets.fromLTRB(20,20,0,0,),
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
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '안녕 나는 김동글 이고 축구를 좋아해 친하게 지내자',
                    style: TextStyle(
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
