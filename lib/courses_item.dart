import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/course_settings/course_settings.dart';
import 'package:schedule/courses_item_child.dart';
import 'package:schedule/services/service.dart' show curWeekFs;
import 'package:schedule/utils/constants.dart' show GRID_COURSES_BG;

class CourseItem extends StatefulWidget {
  CourseItem({
    Key key,
    @required this.courseInfoList,
    @required this.minHeight,
  })
      : assert(courseInfoList != null),
        assert(minHeight != null),
        super(key: key);

  final List<CourseModel> courseInfoList;
  final double minHeight;

  @override
  State<StatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  @override
  Widget build(BuildContext context) {
    int maxStart = 0;
    int maxStep = 0;
    final courses = widget.courseInfoList.reversed;

    courses.forEach((info) {
      if (info.start > maxStart) maxStart = info.start;
      if (info.step > maxStep) maxStep = info.step;
    });

    return SizedBox(
      height: widget.minHeight * maxStep,
      child: GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[]..addAll(
            /// Reverse to make the first at top
              courses.map((courseInfo) {
              return CourseItemChild(
                courseInfo: courseInfo,
              );
              }))..addAll(courses.length > 1
              ? [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
              child: Container(
                width: double.infinity,
                child: Text(
                  '${courses.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]
              : []),
        ),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext ctx0) {
              if (courses.length == 1) {
                return CourseSettings(
                  title: '修改课程',
                  course: courses.first,
                  modifying: true,
                );
              } else {
                return Material(
                  color: Colors.white54,
                  child: GridView(
                    padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    children: courses.map((course) {
                      bool isCurWeek = course.weeks.contains(curWeekFs);
                      return GridTile(
                        child: GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: GRID_COURSES_BG,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              '${isCurWeek ? '' : '[非本周]'}${course
                                  .name}@${course.room}\n${course.teacher}',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: ctx0,
                              builder: (BuildContext _) {
                                return CourseSettings(
                                  title: '修改课程',
                                  course: course,
                                  modifying: true,
                                );
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
