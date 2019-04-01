import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/course.model.dart' show CourseModel;
import 'package:schedule/services/service.dart' show coursesFs;
import 'package:schedule/services/service.dart' show updateState$;
import 'package:schedule/utils/constants.dart' show PREFS_ALL_COURSES;
import 'package:schedule/utils/course_util.dart' show getValidCourses;
import 'package:schedule/utils/util.dart' show getTotalCount, getWeeks;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipedetector/swipedetector.dart';
import 'package:toast/toast.dart';

class CourseSettings extends StatefulWidget {
  CourseSettings({Key key, this.title, this.course, this.modifying})
      : super(key: key);

  final String title;
  final CourseModel course;

  final bool modifying;

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

  int _groupWeekday = 1;

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

  void _removeCurCourse() {
    final CourseModel course = widget.course;
    coursesFs.remove(coursesFs.firstWhere((el) {
      return course.name == el.name &&
          course.room == el.room &&
          course.teacher == el.teacher &&
          course.start == el.start &&
          course.step == el.step &&
          course.weekday == el.weekday &&
          course.weeks.length == el.weeks.length &&
          course.weeks.every((week) => el.weeks.contains(week));
    }));
  }

  void _saveCourse(CourseModel course) {
    setState(() {
      coursesFs.add(CourseModel(
        name: this.name,
        room: this.room,
        teacher: this.teacher,
        start: this.start,
        step: this.step,
        weekday: this.weekday,
        weeks: this.weeks,
      ));
    });
  }

  void _modifyCourse(CourseModel course) {
    setState(() {
      _removeCurCourse();

      coursesFs.add(CourseModel(
        name: this.name,
        room: this.room,
        teacher: this.teacher,
        start: this.start,
        step: this.step,
        weekday: this.weekday,
        weeks: this.weeks,
      ));
    });
  }

  bool _checkInvalid() {
    return getValidCourses(coursesFs, weekdays: [this.weekday]).any((course) {
      return course.invalidOverlaps(
        inCourses: coursesFs,
        weekday: this.weekday,
        start: this.start,
        step: this.step,
      );
    });
  }

  void _changeStorage() {
    SharedPreferences.getInstance().then((p) {
      p.setString(PREFS_ALL_COURSES,
          json.encode(coursesFs.map((v) => v.toMap()).toList()));
    });
    updateState$.add(true);
  }

  void _onCancelBtnPressed() {
    if (widget.modifying == true) {
      _removeCurCourse();
    }
    Navigator.pop(context);
    _changeStorage();
  }

  void _onSaveBtnPressed() {
    if (widget.modifying == true) {
      _modifyCourse(widget.course);
      Navigator.pop(context);
    } else {
      if (_checkInvalid()) {
        return Toast.show('课程时间不允许交叉, 请重新设置', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      } else {
        _saveCourse(widget.course);
        Navigator.pop(context);
      }
    }
    _changeStorage();
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

  void _loadCourseInfo() {
    if (widget.course == null) return;
    setState(() {
      CourseModel course = widget.course;
      this.name = course.name;
      this.room = course.room;
      this.teacher = course.teacher;
      this.start = course.start;
      this.step = course.step;
      this.weeks = course.weeks;
      // Important to set radio group value
      this._groupWeekday = this.weekday = course.weekday;
    });
  }

  @override
  void initState() {
    _loadCourseInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// `skip` + `take` + 1 == 1 to generate from 1
    int skip = -8;
    final take = 8;
    final weekCount = getWeeks().length ~/ take + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
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
                      this.name = value.trim();
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
                      this.room = value.trim();
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
                      this.teacher = value.trim();
                    });
                  },
                ),
              ],
            ),
            ExpansionTile(
              leading: Text('星        期:'),
              title: Text('${this._groupWeekday}'),
              initiallyExpanded: true,
              children: <Widget>[
                Row(
                  children: List.generate(7, (idx) {
                    return Expanded(
                      child: Column(
                        children: <Widget>[
                          Text('${idx + 1}'),
                          Radio<int>(
                            value: idx + 1,
                            groupValue: _groupWeekday,
                            onChanged: (value) {
                              setState(() {
                                this._groupWeekday = value;
                                this.weekday = value;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            ExpansionTile(
              leading: Text('周        数:'),
              title: Text('${this.weeks.join(', ')}'),
              children: List.generate(weekCount, (idx) {
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
                    color: widget.modifying == true ? Colors.red : null,
                    child: Text(
                      widget.modifying == true ? '删除' : '取消',
                      style: TextStyle(
                          color: widget.modifying == true
                              ? Colors.white
                              : Colors.blueAccent),
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
