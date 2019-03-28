import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './empty_box.dart';

import './empty.model.dart';
import './courses.model.dart';

import './utils/util.dart' show getTotalCount;
import './utils/course_util.dart'
    show generateCourses, getSortedVaildCourses, getFilledCourses;

class CourseItem extends StatefulWidget {
  CourseItem({
    Key key,
    this.classInfo,
    this.minHeight,
  })  : assert(classInfo != null),
        assert(minHeight != null),
        super(key: key);

  final CourseModel classInfo;
  final double minHeight;

  @override
  State<StatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.minHeight * widget.classInfo.step,
      child: GestureDetector(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            AutoSizeText(
              '${widget.classInfo.name}@${widget.classInfo.room} ${widget.classInfo.teacher}',
              minFontSize: 12,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          Toast.show(
            '${widget.classInfo.weekday} ${widget.classInfo.start}',
            context,
          );
        },
      ),
    );
  }
}
