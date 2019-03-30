import 'package:flutter/material.dart';

import './content.dart';
import './weeks.dart';

class Schedule extends StatefulWidget {
  Schedule({Key key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: <Widget>[
          Weeks(),
          Expanded(
            child: Content(),
          ),
        ],
      ),
    );
  }
}
