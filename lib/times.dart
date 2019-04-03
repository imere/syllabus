import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schedule/services/service.dart' show prefFs, timesFs;
import 'package:schedule/time.model.dart';
import 'package:schedule/utils/constants.dart' show PREFS_TIMES;
import 'package:schedule/utils/util.dart' show getRowCount;

class Times extends StatefulWidget {
  Times({Key key, this.timesHeight}) : super(key: key);

  final double timesHeight;

  @override
  _TimesState createState() => _TimesState();
}

class _TimesState extends State<Times> {
  double _itemHeight;

  @override
  Widget build(BuildContext context) {
    _itemHeight = widget.timesHeight / getRowCount();

    return SizedBox(
      height: widget.timesHeight,
      child: Column(
        children: List.generate(
            getRowCount(),
                (idx) =>
                GestureDetector(
                  child: _buildTimeItem(n: idx + 1, height: _itemHeight),
                  onTap: () async {
                    timesFs['${idx + 1}'] = null;
                    try {
                      TimeOfDay time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        timesFs['${idx + 1}'] =
                            TimeModel(hours: time.hour, minutes: time.minute)
                                .toString();
                      });
                    } catch (_) {
                      timesFs['${idx + 1}'] = null;
                    }
                    setState(() {
                      prefFs.setString(PREFS_TIMES, json.encode(timesFs));
                    });
                  },
                )),
      ),
    );
  }
}

Container _buildTimeItem({@required int n, @required double height}) {
  String time = '';

  try {
    time = timesFs['$n'] == null ? '' : timesFs['$n'].toString();
  } catch (_) {}

  return Container(
    height: height,
    child: Center(
      child: Text(
        '$n\n$time',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
