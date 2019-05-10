import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/course_settings/course_settings.dart';
import 'package:schedule/preload.dart';
import 'package:schedule/ring.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule/services/service.dart'
    show updateState$, prefFs, selectedColorFs, timesFs, curWeekFs, coursesFs;
import 'package:schedule/settings/settings.dart';
import 'package:schedule/time.model.dart';
import 'package:schedule/utils/constants.dart'
    show MD_COLORS, PREFS_CURRENT_WEEK;
import 'package:schedule/utils/course_util.dart' show getValidCourses;
import 'package:schedule/utils/util.dart' show getWeeks;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  /// Set global instance
  prefFs = await SharedPreferences.getInstance();

//  await AndroidAlarmManager.initialize();

  preload();

  runApp(App());

//  await AndroidAlarmManager.periodic(
//    const Duration(minutes: 1),
//    0,
//    () {
//      print('${DateTime.now().toIso8601String()} ${Isolate.current.hashCode}');
//    },
//  );
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
  /// Check time matched for alarm
  void _checkTimeMatches() {
    List<CourseModel> matched;
    matched = getValidCourses(coursesFs, weekdays: [DateTime
        .now()
        .weekday
    ])
        .where((course) {
      try {
        TimeModel time = TimeModel.fromString(timesFs['${course.start}']);
        return (course.weeks.contains(curWeekFs)) &&
            (time ==
                TimeModel.fromString(
                    '${DateTime
                        .now()
                        .hour}:${DateTime
                        .now()
                        .minute}'));
      } catch (_) {
        /// In case of `timeFs[key]` == null
        return false;
      }
    })
        .toList()
        .cast<CourseModel>();

    if (matched != null && matched.isNotEmpty) {
      showDialog(context: context, builder: (ctx) => Ring(courses: matched));
    }
    Future.delayed(Duration(minutes: 1), _checkTimeMatches);
  }

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
          ),
        );
      },
    );
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      _checkTimeMatches();
    });
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
        ],
      ),
      body: Schedule(),
    );
  }
}
