import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import './course.model.dart';

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
    return Container(
      constraints: BoxConstraints(minHeight: double.infinity),
      margin: EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: AutoSizeText(
        '${widget.courseInfo.name}@${widget.courseInfo.room} ${widget.courseInfo.teacher}',
        minFontSize: 12,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
