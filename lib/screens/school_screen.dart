import 'package:flutter/material.dart';

void main() {
  runApp(NoticeBoardApp());
}

class NoticeBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notice Board',
      home: NoticeListScreen(),
    );
  }
}

class NoticeListScreen extends StatelessWidget {
  final List<String> notices = [
    '학교 행사 안내',
    '시험 일정 변경 안내',
    '급식 식단 안내',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '공지사항',
          style: TextStyle(fontSize: 40.0),
        ),
        backgroundColor: Colors.yellow[200], // Set the background color of appBar to light yellow
      ),
      body: Container(
        color: Colors.yellow[200], // Set the background color of body to light yellow
        child: ListView.builder(
          itemCount: notices.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                notices[index],
                style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                '날짜: ${_getFormattedDate(DateTime.now())}',
                style: const TextStyle(fontSize: 15.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoticeDetailScreen(noticeTitle: notices[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    return '${date.year}.${date.month}.${date.day}'; // Format the date as desired
  }
}

class NoticeDetailScreen extends StatelessWidget {
  final String noticeTitle;

  NoticeDetailScreen({required this.noticeTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticeTitle, style: TextStyle(fontSize: 40.0)),
        backgroundColor: Colors.yellow[200], // Set the background color of appBar to light yellow
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '여기에 선택한 공지사항의 상세 내용을 표시합니다.',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      backgroundColor: Colors.yellow[200], // Set the background color of body to light yellow
    );
  }
}
