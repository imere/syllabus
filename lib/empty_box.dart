import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './course_util.dart' show getTotalCount;

class EmptyBox extends StatefulWidget {
  /// is located at column [weekday] and row [start],
  /// span [count] rows which height is [minHeight]
  EmptyBox({
    Key key,
    @required this.weekday,
    @required this.start,
    @required this.count,
    @required this.minHeight,
  }) : super(key: key);

  final int weekday;
  final int start;
  final int count;
  final double minHeight;

  @override
  _EmptyBoxState createState() => _EmptyBoxState();
}

class _EmptyBoxState extends State<EmptyBox> {
  @override
  Widget build(BuildContext context) {
    var step = widget.count;

    /// build EmptyBox to fill the one column from `start` in order
    var _ = List.generate(step, (idx) => idx + 1);

    return SizedBox(
      height: widget.minHeight * widget.count,
      child: Column(
        children: _.map((start) {
          return SingleItem(
            weekday: widget.weekday,
            start: start,
            height: widget.minHeight,
          );
        }).toList(),
      ),
    );
  }
}

class SingleItem extends StatefulWidget {
  /// located at column [weekday] where row
  /// is [start] with minimum [height]
  SingleItem({
    Key key,
    @required this.weekday,
    @required this.start,
    @required this.height,
  }) : super(key: key);

  final int weekday;
  final int start;
  final double height;

  @override
  State<StatefulWidget> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Center(
        child: Text(
          'TODO',
        ),
      ),
    );
  }
}
