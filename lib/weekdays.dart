import 'package:flutter/material.dart';
import 'package:schedule/utils/util.dart' show getWeekdays;

var weekdays = getWeekdays();

class Weeks extends StatefulWidget {
  Weeks({Key key}) : super(key: key);

  @override
  _WeeksState createState() => _WeeksState();
}

class _WeeksState extends State<Weeks> {
  double _totalWidth;
  double _totalHeight;
  double _itemWidth;

  @override
  Widget build(BuildContext context) {
    _totalWidth = MediaQuery.of(context).size.width;
    _totalHeight = MediaQuery.of(context).size.height;
    _itemWidth = double.infinity;

    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: _buildMonthColumn(width: _itemWidth),
        ),
      ]
        ..addAll(weekdays.map((week) {
          return Expanded(
            flex: 3,
            child: _buildWeekColumn(week: week, width: _itemWidth),
          );
        })),
    );
  }
}

Column _buildMonthColumn({double width}) {
  return Column(
    children: <Widget>[
      SizedBox(
        width: width,
        child: Text(
          '${DateTime.now().month}\n月',
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}

Column _buildWeekColumn({String week, double width}) {
  return Column(
    children: <Widget>[
      SizedBox(
        width: width,
        child: Text(
          week,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
