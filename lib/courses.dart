import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/courses_item.dart';
import 'package:schedule/empty.model.dart';
import 'package:schedule/empty_box.dart';
import 'package:schedule/services/service.dart' show coursesFs, updateState$;
import 'package:schedule/utils/course_util.dart' show getProcessedCourses;
import 'package:schedule/utils/util.dart' show getRowCount;

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
    _minHeight = widget.coursesHeight / getRowCount();

    return SizedBox(
      height: widget.coursesHeight,
      child: CourseColumn(
        weekday: widget.weekday,
        minItemHeight: _minHeight,
      ),
    );
  }
}

class CourseColumn extends StatefulWidget {
  CourseColumn({
    @required this.minItemHeight,
    @required this.weekday,
  });

  final double minItemHeight;
  final int weekday;

  @override
  State<StatefulWidget> createState() => _CourseColumnState();
}

class _CourseColumnState extends State<CourseColumn> {
  @override
  void initState() {
    updateState$.listen((_) => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List c = getProcessedCourses(
      courses: coursesFs,
      weekday: widget.weekday,
      minHeight: widget.minItemHeight,
    );

    return Column(
      children: c.map((item) {
        if (item is CourseModel) {
          return CourseItem(
            courseInfoList: [item],
            minHeight: widget.minItemHeight,
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
            minHeight: widget.minItemHeight,
          );
        } else {
          throw Exception('`item` type not supported ');
        }
      }).toList(),
    );
  }
}
