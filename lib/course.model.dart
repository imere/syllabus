import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule/utils/course_util.dart' show getValidCourses;

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
    List<int> weeksTmp = [];
    (json['weeks'] as List).forEach((v) => weeksTmp.add(v));

    return CourseModel(
      name: json['name'] as String,
      room: json['room'] as String,
      teacher: json['teacher'] as String,
      start: json['start'] as int,
      step: json['step'] as int,
      weekday: json['weekday'] as int,
      weeks: weeksTmp,
    );
  }

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'room')
  String room;

  @JsonKey(name: 'teacher')
  String teacher;

  @JsonKey(name: 'weekday')
  int weekday;

  @JsonKey(name: 'start')
  int start;

  @JsonKey(name: 'step')
  int step;

  @JsonKey(name: 'weeks')
  List<int> weeks;

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

  @override
  bool operator ==(Object other) =>
      other is CourseModel &&
          this.name == other.name &&
          this.room == other.room &&
          this.teacher == other.teacher &&
          this.start == other.start &&
          this.step == other.step &&
          this.weekday == other.weekday &&
          this.weeks.length == other.weeks.length &&
          this.weeks.every((week) => other.weeks.contains(week));

  @override
  get hashCode =>
      name.hashCode * 31 ^
      room.hashCode * 31 ^
      teacher.hashCode * 31 ^
      start.hashCode * 31 ^
      step.hashCode * 31 ^
      weekday.hashCode * 31 ^
      weeks.hashCode;

  bool invalidOverlaps({
    @required List<CourseModel> inCourses,
    @required int weekday,
    @required int start,
    @required int step,
  }) {
    List<CourseModel> list = getValidCourses(
      inCourses,
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
