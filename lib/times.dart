import 'package:flutter/material.dart';

import './utils/util.dart' show getTotalCount;

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
    _itemHeight = widget.timesHeight / getTotalCount();

    final times = List.generate(getTotalCount(), (idx) => idx + 1);

    return SizedBox(
      height: widget.timesHeight,
      child: Column(
        children: times.map((n) {
          return _buildTimeItem(n: n, height: _itemHeight);
        }).toList(),
      ),
    );
  }
}

SizedBox _buildTimeItem({@required int n, @required double height}) {
  return SizedBox(
    height: height,
    child: Center(
      child: Text(
        '$n',
        textAlign: TextAlign.center,
      ),
    ),
  );
}
