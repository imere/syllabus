import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/course_settings/course_settings.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule/services/service.dart' show updateState$, curWeekFs;
import 'package:schedule/services/service.dart' show coursesFs;
import 'package:schedule/utils/constants.dart'
    show THEME_PRIMARY_SWATCH, MAIN_APPBAR_BG;
import 'package:schedule/utils/constants.dart'
    show PREFS_CURRENT_WEEK, PREFS_ALL_COURSES;
import 'package:schedule/utils/util.dart' show getWeeks;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadCurWeek() async {
  final pref = await SharedPreferences.getInstance();
  curWeekFs = pref.getInt(PREFS_CURRENT_WEEK) ?? 1;
}

Future<void> loadCourses() async {
  final pref = await SharedPreferences.getInstance();
  List tmpList = json.decode(pref.getString(PREFS_ALL_COURSES) ?? '[]');
  tmpList.forEach((map) => coursesFs.add(CourseModel.fromMap(map)));
}

Future<void> main() async {
  await loadCurWeek();
  await loadCourses();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '课程表',
      theme: ThemeData(
        primarySwatch: THEME_PRIMARY_SWATCH,
      ),
      home: HomePage(title: '课程表'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _setCurWeek(int week) {
    curWeekFs = week;
    setState(() {
      SharedPreferences.getInstance().then((p) {
        p.setInt(PREFS_CURRENT_WEEK, week);
      });
    });
  }

  void _changeWeek() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                looping: true,
                onSelectedItemChanged: (idx) {
                  _setCurWeek(idx + 1);
                },
                children: getWeeks()
                    .map((week) =>
                    Text(
                      '$week',
                      style: TextStyle(fontSize: 30),
                    ))
                    .toList(),
              ));
        });
  }

  @override
  void initState() {
    /// Get update signal from others
    updateState$.listen((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Row(
            children: <Widget>[
              Text('第$curWeekFs周'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          onTap: _changeWeek,
        ),
        centerTitle: true,
        backgroundColor: MAIN_APPBAR_BG,
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CourseSettings(
                    title: '添加课程',
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Schedule(),
    );
  }
}
