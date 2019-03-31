import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/courses_item_child.dart';
import 'package:toast/toast.dart';

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
    widget.courseInfoList.forEach((info) {
      if (info.start > maxStart) maxStart = info.start;
      if (info.step > maxStep) maxStep = info.step;
    });

    return SizedBox(
      height: widget.minHeight * maxStep,
      child: GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[]..addAll(
            // reverse to make the first at top
            widget.courseInfoList.reversed.map((courseInfo) {
              return CourseItemChild(
                courseInfo: courseInfo,
              );
            }),
          )..addAll(widget.courseInfoList.length > 1
              ? [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.green),
              child: Container(
                width: double.infinity,
                child: Text(
                  '${widget.courseInfoList.length}',
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
          Toast.show(
            '${widget.courseInfoList.first.weekday} $maxStart,$maxStep',
            context,
          );
        },
      ),
    );
  }
}
