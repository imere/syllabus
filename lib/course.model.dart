import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/utils/course_util.dart' show getValidCourses;
import 'package:schedule/utils/util.dart' show generateCourses;

@JsonSerializable(nullable: true)
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

  factory CourseModel.fromMap(Map<String, dynamic> json) {
    return CourseModel(
      name: json['name'] as String,
      room: json['room'] as String,
      teacher: json['teacher'] as String,
      start: json['start'] as int,
      step: json['step'] as int,
      weekday: json['weekday'] as int,
      weeks: json['weeks'] as List,
    );
  }

  String name;
  String room;
  String teacher;
  int weekday;
  int start;
  int step;
  List weeks;

  Map<String, dynamic> toMap() =>
      <String, dynamic>{
        'name': this.name,
        'room': this.room,
        'teacher': this.teacher,
        'start': this.start,
        'step': this.step,
        'weekday': this.weekday,
        'weeks': this.weeks,
      };

  bool invalidOverlaps({
    @required int weekday,
    @required int start,
    @required int step,
  }) {
    List<CourseModel> list = getValidCourses(
      generateCourses(),
      weekdays: [weekday],
    );

    return list.any((course) {
      if ((start + step > course.start) &&
          (start < course.start + course.step)) {
        if (((start == course.start) && (step == course.step))) {
          return false;
        } else {
          return true;
        }
      }
      return false;
    });
  }
}
