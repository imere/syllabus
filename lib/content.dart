import 'package:flutter/material.dart';
import 'package:schedule/courses.dart';
import 'package:schedule/times.dart';
import 'package:schedule/weekdays.dart' show weekdays;

class Content extends StatefulWidget {
  Content({Key key}) : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  /// max height of [Content]
  double _contentHeight;

  @override
  Widget build(BuildContext context) {
    _contentHeight =
        MediaQuery
            .of(context)
            .size
            .height * 1.5; // scale is free to change

    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Times(timesHeight: _contentHeight),
          ),
        ]
          ..addAll(weekdays.map((weekday) {
            return Expanded(
              flex: 7,
              child: Courses(
                coursesHeight: _contentHeight,
                weekday: weekdays.indexOf(weekday) + 1,
              ),
            );
          })),
      ),
    );
  }
}
