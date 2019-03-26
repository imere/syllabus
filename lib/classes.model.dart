import 'package:flutter/material.dart';

final classes = [
  Classes(
    name: '阿斯利康大家爱丽丝看人家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家爱丽丝看人',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家爱丽丝家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家爱丽家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家爱家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康大家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利康家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯利家',
    room: '12-121',
    weekdays: [],
  ),
  Classes(
    name: '阿斯家',
    room: '12-121',
    weekdays: [],
  ),
];

class Classes {
  Classes({
    @required this.name,
    @required this.room,
    this.teacher = '',
    this.start = -1,
    this.step = 1,
    @required this.weekdays,
  });

  String name;
  String room;
  String teacher;
  int start;
  int step;
  List weekdays;
}
