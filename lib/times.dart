import 'package:flutter/material.dart';
import 'package:schedule/services/service.dart' show timesFs;
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

    // Sort before using
    timesFs.sort((a, b) => a.gt(b) ? 1 : -1);

    return SizedBox(
      height: widget.timesHeight,
      child: Column(
        children: List.generate(getRowCount(),
                (idx) => _buildTimeItem(n: idx + 1, height: _itemHeight)),
      ),
    );
  }
}

Container _buildTimeItem({@required int n, @required double height}) {
  String time = '';

  try {
    time = timesFs.elementAt(n - 1).toString();
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
