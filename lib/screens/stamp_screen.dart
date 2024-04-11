import 'package:flutter/material.dart';
import 'package:pocekt_teacher/constants.dart';

class StampScreen extends StatefulWidget {
  const StampScreen({super.key});

  @override
  State<StampScreen> createState() => _StampScreenState();
}

class _StampScreenState extends State<StampScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: children_light,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const TitleCard(
              title: '(name)의 도장 보관함',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: const [
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                    Stamp(),
                  ],
                ),
              ),
            ),
            const NameCard(),
            const NameCard(),
            const NameCard(),
            Container(
              width: 30,
            )
          ],
        ),
      ),
    );
  }
}

class Stamp extends StatelessWidget {
  const Stamp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.amber,
      child: const Text('Text Stamp'),
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(title)),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('(ranking) (name) (number of stamp)'),
      ),
    );
  }
}
