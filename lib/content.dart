import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './times.dart';
import './courses.dart';
import './weeks.dart' show weeks;

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
        MediaQuery.of(context).size.height * 1.2; // scale 1.2 is free to change

    return SingleChildScrollView(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Times(timesHeight: _contentHeight),
          ),
        ]..addAll(weeks.map((weekday) {
            return Expanded(
              child: Courses(
                coursesHeight: _contentHeight,
                weekday: weeks.indexOf(weekday) + 1,
              ),
            );
          })),
      ),
    );
  }
}
