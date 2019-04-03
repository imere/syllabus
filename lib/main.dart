import 'dart:isolate';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course_settings/course_settings.dart';
import 'package:schedule/preload.dart';
import 'package:schedule/ring.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule/services/service.dart'
    show updateState$, prefFs, selectedColorFs, curWeekFs;
import 'package:schedule/settings/settings.dart';
import 'package:schedule/utils/constants.dart'
    show MD_COLORS, PREFS_CURRENT_WEEK;
import 'package:schedule/utils/util.dart' show getWeeks;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  /// Set global instance
  prefFs = await SharedPreferences.getInstance();

  await AndroidAlarmManager.initialize();

  preload();

  runApp(App());

  await AndroidAlarmManager.periodic(
    const Duration(seconds: 10),
    0,
        () {
      print('${DateTime.now().toIso8601String()} ${Isolate.current.hashCode}');
    },
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Syllabus',
      theme: ThemeData(
        primarySwatch: MD_COLORS[selectedColorFs],
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
      prefFs.setInt(PREFS_CURRENT_WEEK, week);
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
        backgroundColor: MD_COLORS[selectedColorFs],
        brightness: Brightness.dark,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return CourseSettings(
                    title: '添加课程',
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return Settings(title: '设置');
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return Ring();
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
