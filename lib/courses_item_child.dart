import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/services/service.dart' show curWeek;

class CourseItemChild extends StatefulWidget {
  CourseItemChild({
    @required this.courseInfo,
  }) : assert(courseInfo != null);

  final CourseModel courseInfo;

  @override
  State<StatefulWidget> createState() => _CourseItemChildState();
}

class _CourseItemChildState extends State<CourseItemChild> {
  @override
  Widget build(BuildContext context) {
    bool isCurWeek = curWeek == widget.courseInfo.weekday;

    return Container(
      constraints: BoxConstraints(minHeight: double.infinity),
      margin: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: isCurWeek ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: AutoSizeText(
        '${isCurWeek ? '' : '[非本周]'}${widget.courseInfo.name}@${widget
            .courseInfo.room} ${widget.courseInfo.teacher}',
        minFontSize: 12 *
            MediaQuery
                .of(context)
                .size
                .height /
            MediaQuery
                .of(context)
                .size
                .width /
            1.5,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isCurWeek ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
