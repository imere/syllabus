import 'package:schedule/course.model.dart';
import 'package:schedule/services/service.dart' show voicesFs, selectedVoiceFs;

int getRowCount() {
  /// Even number
  return 2 * 7;
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

/// Check whether current voice resource is valid
bool checkResourceValid() =>
    voicesFs[selectedVoiceFs] != '' && voicesFs[selectedVoiceFs] != null;

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
      start: 5,
      step: 2,
      weekday: 1,
      weeks: [1, 3, 5, 7, 9],
    ),
  ]);
  return list;
}
