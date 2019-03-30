import '../course.model.dart';

int getTotalCount() {
  // even number
  return 2 * 7;
}

List<CourseModel> generateCourses() {
  List<CourseModel> list = [];
  list.addAll([
    CourseModel(
      name: '阿斯利康大家爱丽丝看人家',
      room: '7-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家爱丽丝看人',
      room: '8-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家爱丽丝家',
      room: '9-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家爱丽家',
      room: '10-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家爱家',
      room: '11-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家家',
      room: '12-121',
      start: 1,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
    CourseModel(
      name: '阿斯利康大家',
      room: '12-110',
      start: 11,
      step: 2,
      weekday: 1,
      weeks: [1, 2, 3],
    ),
  ]);
  return list;
}
