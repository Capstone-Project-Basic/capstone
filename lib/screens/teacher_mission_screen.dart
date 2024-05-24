import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MissionPage(),
    );
  }
}

class MissionPage extends StatelessWidget {
  const MissionPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(226, 210, 125, 0.4),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              '현재 등록된 미션이 없습니다',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MissionRegistrationPage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(234, 210, 129, 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Mission',
                  style: TextStyle(
                    color: Colors.white, fontSize: 34.0,
                    fontWeight: FontWeight.bold,),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MissionRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션등록', style: TextStyle(fontFamily: "dongle", fontSize: 30),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: '미션을 입력하세요',),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MissionGradeButton(grade: '상', color: Colors.orange),
                  MissionGradeButton(grade: '중', color: Colors.grey),
                  MissionGradeButton(grade: '하', color: Colors.yellow),],
              ),
            ),
            const SizedBox(height: 200.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MissionEditingPage()),);
              },
              child: const Text('미션 등록', style: TextStyle( fontFamily: "dongle", fontSize: 25),),
            ),
          ],
        ),
      ),
    );
  }
}

class MissionEditingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('미션 편집', style: TextStyle(fontSize: 30, fontFamily: "dongle"),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: '미션을 편집하세요',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                  },
                  child: const Text('편집', style: TextStyle(fontFamily: "dongle", fontSize: 25)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('완료하기', style: TextStyle(fontFamily: "dongle", fontSize: 25)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MissionGradeButton extends StatelessWidget {
  final String grade;
  final Color color;

  const MissionGradeButton({required this.grade, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(color),
      ),
      child: Text(
        grade,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
