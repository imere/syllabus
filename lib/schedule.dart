import 'package:flutter/material.dart';
import 'package:schedule/content.dart';
import 'package:schedule/weekdays.dart';

class Schedule extends StatefulWidget {
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Weeks(),
            Expanded(
              child: Content(),
            ),
          ],
        ),
      ),
    );
  }
}
