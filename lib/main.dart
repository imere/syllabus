import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course_settings/course_settings.dart';
import 'package:schedule/schedule.dart';
import 'package:schedule/services/service.dart' show curWeek;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '课程表',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  int _week = 1;

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
                  setState(() {
                    this._week = idx + 1;
                    curWeek = this._week;
                    _setCurWeek(curWeek);
                  });
                },
                children: List.generate(30, (idx) => idx + 1)
                    .map((v) =>
                    Text(
                      '$v',
                      style: TextStyle(fontSize: 30),
                    ))
                    .toList(),
              ));
        });
  }

  void _setCurWeek(int week) {
    SharedPreferences.getInstance().then((p) {
      p.setInt('curWeek', week);
    });
  }

  void loadCurWeek() {
    SharedPreferences.getInstance().then((p) {
      setState(() {
        _week = p.getInt('curWeek') ?? 1;
        curWeek = _week;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    loadCurWeek();

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Row(
            children: <Widget>[
              Text('第$_week周'),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          onTap: _changeWeek,
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(
            255, num.parse('0x8B'), num.parse('0x81'), num.parse('0xC3')),
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
          )
        ],
      ),
      body: Schedule(),
    );
  }
}
