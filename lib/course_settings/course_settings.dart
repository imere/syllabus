import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:toast/toast.dart';

import '../course.model.dart' show CourseModel;
import '../utils/course_util.dart' show getValidCourses;
import '../utils/util.dart' show getTotalCount, getWeeks, generateCourses;

class CourseSettings extends StatefulWidget {
  CourseSettings({Key key, this.title, this.course}) : super(key: key);

  final String title;
  final CourseModel course;

  @override
  State<StatefulWidget> createState() => _CourseSettingsState();
}

class _CourseSettingsState extends State<CourseSettings> {
  String name = '';
  String room = '';
  String teacher = '';
  int start = 1;
  int step = 1;
  int weekday = 1;
  List<int> weeks = getWeeks();

  void _onStartBtnPressed() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            child: CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged: (idx) {
                setState(() {
                  this.start = idx + 1;
                  if (this.start + this.step > getTotalCount() + 1) {
                    this.step = getTotalCount() - this.start + 1;
                  }
                });
              },
              children: List.generate(getTotalCount(), (idx) => idx + 1)
                  .map((val) => Text(
                        '$val',
                        style: TextStyle(fontSize: 30),
                      ))
                  .toList(),
            ),
          );
        });
  }

  void _onStepBtnPressed() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            child: CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged: (idx) {
                setState(() {
                  this.step = idx + 1;
                });
              },
              children: List.generate(
                      getTotalCount() - this.start + 1, (idx) => idx + 1)
                  .map((val) => Text(
                        '$val',
                        style: TextStyle(fontSize: 30),
                      ))
                  .toList(),
            ),
          );
        });
  }

  void _onCancelBtnPressed() {
    Navigator.pop(context);
  }

  void _onSaveBtnPressed() {
    if (getValidCourses(generateCourses(), weekdays: [this.weekday])
        .any((course) {
      return course.invalidOverlaps(
        weekday: this.weekday,
        start: this.start,
        step: this.step,
      );
    })) {
      return Toast.show('课程时间不允许交叉, 请重新设置', context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  dynamic _swipeAction(int week) {
    setState(() {
      if (this.weeks.contains(week)) {
        this.weeks.remove(week);
      } else {
        this.weeks.add(week);
      }
      this.weeks.sort((a, b) => a - b);
    });
  }

  void _setCourseInfo() {
    if (widget.course == null) return;
    setState(() {
      CourseModel course = widget.course;
      this.name = course.name;
      this.room = course.room;
      this.teacher = course.teacher;
      this.start = course.start;
      this.step = course.step;
      this.weekday = course.weekday;
      this.weeks = course.weeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    _setCourseInfo();

    /// `skip` + `take` + 1 == 1 to generate from 1
    int skip = -8;
    final take = 8;
    final count = getWeeks().length ~/ take + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListView(
          children: <Widget>[
            ExpansionTile(
              leading: Text('课程名称:'),
              title: Text('$name'),
              children: <Widget>[
                TextField(
                  maxLength: 100,
                  maxLengthEnforced: true,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      this.name = value;
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Text('教        室:'),
              title: Text('$room'),
              children: <Widget>[
                TextField(
                  maxLength: 20,
                  maxLengthEnforced: true,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      this.room = value;
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Text('教        师:'),
              title: Text('$teacher'),
              children: <Widget>[
                TextField(
                  maxLength: 100,
                  maxLengthEnforced: true,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      this.teacher = value;
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Text('周        数:'),
              title: Text('${this.weeks.join(', ')}'),
              children: List.generate(count, (idx) => idx + 1).map((row) {
                skip += take;
                return Row(
                  children: getWeeks().skip(skip).take(take).map((week) {
                    return Expanded(
                      child: SwipeDetector(
                        swipeConfiguration: SwipeConfiguration(
                          verticalSwipeMinVelocity: 1.0,
                          verticalSwipeMinDisplacement: 1.0,
                          verticalSwipeMaxWidthThreshold: 300.0,
                          horizontalSwipeMaxHeightThreshold: 200.0,
                          horizontalSwipeMinDisplacement: 1.0,
                          horizontalSwipeMinVelocity: 1.0,
                        ),
                        onSwipeUp: () => _swipeAction(week),
                        onSwipeRight: () => _swipeAction(week),
                        onSwipeDown: () => _swipeAction(week),
                        onSwipeLeft: () => _swipeAction(week),
                        child: Column(
                          children: <Widget>[
                            Text('$week'),
                            Checkbox(
                              value: this.weeks.contains(week),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked) {
                                    if (!this.weeks.contains(week))
                                      this.weeks.add(week);
                                  } else {
                                    this.weeks.removeWhere((v) => v == week);
                                  }
                                  this.weeks.sort((a, b) => a - b);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
            ExpansionTile(
              initiallyExpanded: true,
              leading: Text('时  间  段:'),
              title: Text('开始于: $start, 跨度: $step'),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 50,
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            '$start',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: _onStartBtnPressed,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        width: 0,
                        height: 50,
                      ),
                    ),
                    Expanded(
                      flex: 50,
                      child: GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            '$step',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: _onStepBtnPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    child: Text(
                      '取消',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: _onCancelBtnPressed,
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    child: Text(
                      '保存',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _onSaveBtnPressed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
