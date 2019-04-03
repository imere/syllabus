import 'dart:convert';

import 'package:schedule/course.model.dart';
import 'package:schedule/services/service.dart'
    show
        prefFs,
        selectedColorFs,
        curWeekFs,
        timesFs,
        coursesFs,
        voicesFs,
        selectedVoiceFs;
import 'package:schedule/time.model.dart';
import 'package:schedule/utils/constants.dart'
    show
        DEFAULT_MD_COLOR,
        PREFS_CURRENT_WEEK,
        PREFS_ALL_COURSES,
        PREFS_TIMES,
        PREFS_CUSTOM_VOICE_PATH,
        CUSTOM_VOICE,
        PREFS_SELECTED_COLOR,
        PREFS_SELECTED_VOICE;

void _loadCurWeek() {
  curWeekFs = prefFs.getInt(PREFS_CURRENT_WEEK) ?? 1;
}

void _loadTimes() {
  json
      .decode(prefFs.getString(PREFS_TIMES) ?? '[]')
      .forEach((map) => timesFs.add(TimeModel.fromMap(map)));
}

void _loadCourses() {
  json
      .decode(prefFs.getString(PREFS_ALL_COURSES) ?? '[]')
      .forEach((map) => coursesFs.add(CourseModel.fromMap(map)));
}

void _loadCustomVoicePath() {
  voicesFs[CUSTOM_VOICE] = prefFs.getString(PREFS_CUSTOM_VOICE_PATH) ?? '';
}

void _loadSelectedVoice() {
  selectedVoiceFs = prefFs.getString(PREFS_SELECTED_VOICE) ?? '';
}

void _loadColor() {
  selectedColorFs = prefFs.getString(PREFS_SELECTED_COLOR) ?? DEFAULT_MD_COLOR;
}

void preload() {
  _loadCurWeek();
  _loadTimes();
  _loadCourses();
  _loadCustomVoicePath();
  _loadSelectedVoice();
  _loadColor();
}
