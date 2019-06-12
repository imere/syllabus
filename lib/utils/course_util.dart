import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/empty.model.dart';
import 'package:schedule/utils/util.dart' show getRowCount;

List<CourseModel> getValidCourses(List<CourseModel> courses, {
  List weekdays = const [1, 2, 3, 4, 5, 6, 7],
}) {
  if (courses.isEmpty) return [];

  List<CourseModel> ret = List.of(courses);

  ret.removeWhere((course) {
    return (course.start < 1) ||
        (course.step < 1) ||
        (course.start + course.step - 1 > getRowCount()) ||
        !weekdays.contains(course.weekday);
  });

  return ret;
}

List<CourseModel> getSortedValidCourses(List<CourseModel> courses, {
  List weekdays = const [1, 2, 3, 4, 5, 6, 7],
}) {
  if (courses.length == 0) return [];

  List list = getValidCourses(courses, weekdays: weekdays);

  list.sort((a, b) => a.start - b.start);

  return list;
}

/// Fill [courses] with [EmptyModel] if needed,
/// then return a new list of type [List<CourseModel|EmptyModel>].
/// [EmptyModel] is used to construct [EmptyBox]
List getFilledCourses({
  @required List<CourseModel> courses,
  @required double minHeight,
  @required int weekday,
}) {
  if (courses.length == 0) return [];

  List ret = [];

  int prevStart = 0;
  int prevStep = 1;

  courses.sort((a, b) => a.start - b.start);

  courses.forEach((course) {
    if (course.start > (prevStart + prevStep)) {
      /// Fill with empty block if there is space between two courses
      ret.add(EmptyModel(
        minHeight: minHeight,
        weekday: weekday,
        start: prevStart + prevStep,
        step: course.start - (prevStart + prevStep),
      ));
      prevStart = prevStart + prevStep - (prevStart + prevStep);
      prevStep = course.start + course.step;
    } else {
      prevStart = course.start;
      prevStep = course.step;
    }

    ret.add(course);
  });

  /// Fill with empty block if there is space at the end
  if (prevStart + prevStep - 1 < getRowCount()) {
    ret.add(EmptyModel(
      minHeight: minHeight,
      weekday: weekday,
      start: prevStart + prevStep,
      step: getRowCount() - (prevStart + prevStep) + 1,
    ));
  }

  return ret;
}

/// Process `courses: List<CourseModel|EmptyModel>`,
/// then return a new list of type `List<CourseModel|EmptyModel|List<CourseModel>>`.
List _handleValidOverlayCourses(List courses) {
  // TODO: improve algorithm
  if (courses.length == 0) return [];

  courses.sort((a, b) => a.start - b.start);

  List ret = [];

  /// Here values are [List], because [EmptyModel]
  /// may also be stored, but they will be processed later
  Map<String, List> map = Map();

  courses.forEach((course) {
    /// Map all exist keys
    String key = '${course.start}-${course.step}';
    if (map[key] == null) map[key] = [];

    map[key].add(course);
  });

  final blocks = List.generate(getRowCount(), (idx) => idx + 1);

  /// Traverse all rows
  blocks.forEach((start) {
    /// Traverse all steps
    blocks.forEach((step) {
      if (map['$start-$step'] == null) return;

      /// The [List] of [EmptyModel] is then flattened
      if (map['$start-$step'].first is EmptyModel) {
        map['$start-$step'].forEach((em) {
          ret.add(em);
        });
        return;
      }

      ret.add(map['$start-$step']);
    });
  });

//  {
//    // Debug
//    for (var item in ret) {
//      if (item is CourseModel) {
//        /// In fact this is not reachable, because [CourseModel] are
//        /// all in the [List]
//        print('C : ${item.start} ${item.step}');
//      } else if (item is EmptyModel) {
//        print('E : ${item.start} ${item.step}');
//      } else {
//        print('L: $item');
//      }
//    }
//    print(ret.length);
//  }

  return ret;
}

List getProcessedCourses({
  List<CourseModel> courses = const [],
  int weekday,
  double minHeight,
}) {
  return _handleValidOverlayCourses(getFilledCourses(
    courses: getSortedValidCourses(courses, weekdays: [weekday]),
    weekday: weekday,
    minHeight: minHeight,
  ));
}
