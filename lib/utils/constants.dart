import 'package:flutter/material.dart';

/// All courses
const PREFS_ALL_COURSES = 'allCourses';

/// Current week
const PREFS_CURRENT_WEEK = 'curWeek';

/// Times
const PREFS_TIMES = 'times';

/// Voice
const PREFS_CUSTOM_VOICE_PATH = 'voicePath';

const PREFS_SELECTED_VOICE = 'selectedVoice';

const DEFAULT_VOICE = 'DefaultVoice';

const CUSTOM_VOICE = 'CustomVoice';

/// courses_item.dart
// ignore: non_constant_identifier_names
final Color GRID_COURSES_BG = Color.fromARGB(
    125, num.parse('0xF4'), num.parse('0xA7'), num.parse('0xB9'));

/// Material theme colors
const PREFS_SELECTED_COLOR = 'selectedColor';

const Map<String, MaterialColor> MD_COLORS = const {
  '知乎蓝': Colors.blue,
  '草原绿': Colors.green,
  '青葱绿': Colors.lightGreen,
  '姨妈红': Colors.red,
  '伊藤橙': Colors.orange,
  '基佬紫': Colors.deepPurple,
  '胭脂粉': Colors.pink,
  '低调灰': Colors.grey,
  '水鸭青': Colors.teal,
  '古铜棕': Colors.brown,
};
const DEFAULT_MD_COLOR = '胭脂粉';
