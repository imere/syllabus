import 'package:rxdart/rxdart.dart';
import 'package:schedule/course.model.dart';
import 'package:schedule/utils/constants.dart'
    show DEFAULT_VOICE, CUSTOM_VOICE, DEFAULT_MD_COLOR;
import 'package:shared_preferences/shared_preferences.dart';

/// Generally get from `*Fs`(from service), set by [SharedPreferences]

/// Send update signal
final updateState$ = PublishSubject<dynamic>();

/// Global instance, init at main.dart
SharedPreferences prefFs;

/// Current week
int curWeekFs = 1;

/// All times
final Map<String, String> timesFs = {};

/// All courses
final List<CourseModel> coursesFs = [];

/// Builtin voices
final Map<String, String> voicesFs = {
  '0': '',
  '1': '',
  '2': '',
  '3': '',
  '4': '',
  DEFAULT_VOICE: 'voice/RSP.mp3',
  CUSTOM_VOICE: '',
};
String selectedVoiceFs = DEFAULT_VOICE;

/// Material theme color
String selectedColorFs = DEFAULT_MD_COLOR;
