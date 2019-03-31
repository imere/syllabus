import 'package:schedule/course.model.dart';

int getTotalCount() {
  // Even number
  return 2 * 7;
}

List<Map<int, String>> getTimesMap() {
  return [
    {1: '8:00'},
    {2: '9:00'},
    {3: '10:00'},
    {4: '11:00'},
    {5: '14:00'},
    {6: '15:00'},
    {7: '16:00'},
    {8: '17:00'},
    {9: '20:00'},
    {10: '21:00'},
  ];
}

List<String> getWeekdays() {
  return [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];
}

List<int> getWeeks() {
  return List.generate(30, (idx) => idx + 1);
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
