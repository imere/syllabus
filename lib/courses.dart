import 'package:flutter/material.dart';

import './course.model.dart';
import './courses_item.dart';
import './empty.model.dart';
import './empty_box.dart';
import './utils/course_util.dart' show processCourses;
import './utils/util.dart' show getTotalCount, generateCourses;

class Courses extends StatefulWidget {
  Courses({
    Key key,
    @required this.coursesHeight,
    @required this.weekday,
  })  : assert(weekday != null),
        assert(coursesHeight != null),
        super(key: key);

  final double coursesHeight;
  final int weekday;

  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  double _minHeight;

  @override
  Widget build(BuildContext context) {
    // Get min box height
    _minHeight = widget.coursesHeight / getTotalCount();

    return SizedBox(
      height: widget.coursesHeight,
      child: _buildCourseColumn(
        weekday: widget.weekday,
        minItemHeight: _minHeight,
      ),
    );
  }
}

Column _buildCourseColumn({
  @required double minItemHeight,
  @required int weekday,
}) {
  List c = processCourses(
    courses: generateCourses(),
    weekday: weekday,
    minHeight: minItemHeight,
  );

  return Column(
    children: c.map((item) {
      if (item is CourseModel) {
        return CourseItem(
          courseInfoList: [item],
          minHeight: minItemHeight,
        );
      } else if (item is EmptyModel) {
        return EmptyBox(
          weekday: item.weekday,
          start: item.start,
          step: item.step,
          minHeight: item.minHeight,
        );
      } else if (item.cast<CourseModel>() is List<CourseModel>) {
        return CourseItem(
          courseInfoList: item.cast<CourseModel>(),
          minHeight: minItemHeight,
        );
      } else {
        throw Exception('`item` type not supported ');
      }
    }).toList(),
  );
}
