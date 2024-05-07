import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/screens/school_screen.dart';


class SchoolPage extends StatelessWidget {
  const SchoolPage({
    super.key,
    required this.buttonImage,
  });

  final Image buttonImage;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.accessibility_rounded),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: sky_deep,
                ),
                Positioned(
                  width: screenSize.width - 300,
                  height: screenSize.height - 700,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 24.0, top: 8.0),
                    child: Image(
                      image: AssetImage('assets/images/sun.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Row(
            children: [
              Expanded(
                  child: Image(
                    image: AssetImage('assets/images/sky.jpeg'),
                  )),
            ],
          ),
          Expanded(
            child: Container(
              color: sky_light,
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                const Image(
                  image: AssetImage('assets/images/green_bg.png'),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  width: screenSize.width - 100,
                  bottom: screenSize.width - 350,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent),
                      foregroundColor:
                      MaterialStatePropertyAll(Colors.transparent),
                      overlayColor:
                      MaterialStatePropertyAll(Colors.transparent),
                      elevation: MaterialStatePropertyAll(0.0),
                    ),
                    child: buttonImage,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NoticeListScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
