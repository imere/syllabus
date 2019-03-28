import 'package:flutter/material.dart';

import '../empty.model.dart';
import '../courses.model.dart';

import './util.dart' show getTotalCount;

List<CourseModel> generateCourses() {
  List<CourseModel> list = [];
  list.addAll([
    // CourseModel(
    //   name: '阿斯利康大家爱丽丝看人家',
    //   room: '7-121',
    //   start: 1,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家爱丽丝看人',
    //   room: '8-121',
    //   start: 3,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家爱丽丝家',
    //   room: '9-121',
    //   start: 5,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家爱丽家',
    //   room: '10-121',
    //   start: 7,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家爱家',
    //   room: '11-121',
    //   start: 9,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家家',
    //   room: '12-121',
    //   start: 11,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康大家',
    //   room: '12-110',
    //   start: 13,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利康家',
    //   room: '12-111',
    //   start: 15,
    //   step: 2,
    //   weekday: 1,
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯利家',
    //   start: 17,
    //   step: 2,
    //   weekday: 1,
    //   room: '12-112',
    //   weeks: [1, 2, 3],
    // ),
    // CourseModel(
    //   name: '阿斯家',
    //   start: 19,
    //   step: 2,
    //   weekday: 1,
    //   room: '12-113',
    //   weeks: [1, 2, 3],
    // ),
  ]);
  return list;
}

List<CourseModel> getSortedVaildCourses(List<CourseModel> courses) {
  var list = courses;

  /// `start` should not be -1
  list.removeWhere((course) {
    return (course.start < 1) ||
        (course.start + course.step - 1 > getTotalCount());
  });

  list.sort((a, b) => a.start - b.start);

  return list;
}

/// Fill [courses] with [EmptyModel] if needed,
/// then return a new list.
/// [EmptyModel] is used to construct [EmptyBox]
List getFilledCourses({
  @required List<CourseModel> courses,
  @required double minHeight,
  @required int weekday,
}) {
  List list = [];
  int prevStart = 0;
  int prevStep = 1;
  courses.sort((a, b) => a.start - b.start);

  courses.forEach((course) {
    if (course.start > (prevStart + prevStep)) {
      // fill with empty block if there is space between two courses
      list.add(EmptyModel(
        minHeight: minHeight,
        weekday: weekday,
        start: prevStart + prevStep,
        count: course.start - (prevStart + prevStep),
      ));
      prevStart = prevStart + prevStep - prevStart - prevStep;
      prevStep = course.start + course.step;
    } else {
      prevStart = course.start;
      prevStep = course.step;
    }

    list.add(course);
  });

  // fill with empty block if there is space at the end
  if (prevStart + prevStep - 1 < getTotalCount()) {
    list.add(EmptyModel(
      minHeight: minHeight,
      weekday: weekday,
      start: prevStart + prevStep,
      count: getTotalCount() - (prevStart + prevStep) + 1,
    ));
  }

  return list;
}
