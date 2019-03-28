import 'package:flutter/material.dart';

class CourseModel {
  /// [start] at column [weekday], span [step] blocks.
  CourseModel({
    @required this.name,
    this.room = '',
    this.teacher = '',
    @required this.start,
    this.step = 2,
    @required this.weekday,
    @required this.weeks,
  })  : assert(null != name),
        assert(null != start),
        assert(null != weekday),
        assert(null != weeks);

  String name;
  String room;
  String teacher;
  int weekday;
  int start;
  int step;
  List weeks;
}
