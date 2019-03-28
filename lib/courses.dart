import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './empty_box.dart';

import './empty.model.dart';
import './courses.model.dart';
import './course_util.dart'
    show
        getTotalCount,
        generateCourses,
        getSortedVaildCourses,
        getFilledCourses;

class Courses extends StatefulWidget {
  Courses({Key key, this.coursesHeight, this.weekday})
      : assert(weekday != null),
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
    // get min box height
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
  var c = getFilledCourses(
    courses: getSortedVaildCourses(generateCourses()),
    weekday: weekday,
    minHeight: minItemHeight,
  );
  for (var item in c) {
    if (item is CourseModel) {
      print('C: ${item.start} ${item.step}');
    } else if (item is EmptyModel) {
      print('E: ${item.start} ${item.count}');
    }
  }
  print(c.length);

  return Column(
    children: c.map((item) {
      if (item is CourseModel) {
        return _buildCourseItem(classInfo: item, minHeight: minItemHeight);
      } else if (item is EmptyModel) {
        return EmptyBox(
          key: Key('${c.indexOf(item) + 1}'),
          weekday: item.weekday,
          start: item.start,
          count: item.count,
          minHeight: item.minHeight,
        );
      }
    }).toList(),
  );
}

SizedBox _buildCourseItem({
  @required CourseModel classInfo,
  @required double minHeight,
}) {
  return SizedBox(
    height: minHeight * classInfo.step,
    child: Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        AutoSizeText(
          '${classInfo.name}@${classInfo.room} ${classInfo.teacher}',
          minFontSize: 12,
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
