import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

const times = [
  '8:00',
  '9:00',
  '10:00',
  '11:00',
  '14:00',
  '15:00',
  '16:00',
  '17:00',
  '20:00',
  '21:00',
];

class Times extends StatefulWidget {
  Times({Key key, this.timesHeight}) : super(key: key);

  final timesHeight;

  @override
  _TimesState createState() => _TimesState();
}

class _TimesState extends State<Times> {
  var _itemHeight;

  @override
  Widget build(BuildContext context) {
    _itemHeight = widget.timesHeight / times.length;

    return SizedBox(
      height: widget.timesHeight,
      child: Column(
        children: times.map((time) {
          return _buildTimeItem(time: time, height: _itemHeight);
        }).toList(),
      ),
    );
  }
}

SizedBox _buildTimeItem({@required String time, @required double height}) {
  return SizedBox(
    height: height,
    child: Center(
      child: Text(
        '${times.indexOf(time) + 1}\n$time',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
