import 'package:rxdart/rxdart.dart';
import 'package:schedule/course.model.dart';

final updateState$ = PublishSubject<dynamic>();

/// Current week
int curWeekFs = 1;

/// All courses
List<CourseModel> coursesFs = [];
