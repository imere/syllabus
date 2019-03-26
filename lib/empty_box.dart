import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './times.dart' show times;

class EmptyBox extends StatefulWidget {
  EmptyBox({
    Key key,
    @required this.weekday,
    @required this.start,
    @required this.count,
    @required this.boxHeight,
  }) : super(key: key);

  final weekday;
  final start;
  final count;
  final boxHeight;

  @override
  _EmptyBoxState createState() => _EmptyBoxState();
}

class _EmptyBoxState extends State<EmptyBox> {
  var _singleHeight;

  @override
  Widget build(BuildContext context) {
    _singleHeight = widget.boxHeight / times.length;
    var step = widget.count;

    /// build `count` EmptyBox to fill the one column from `start` in order
    var _ = List.generate(widget.count, (idx) => widget.start + (step++));

    return SizedBox(
      height: widget.boxHeight,
      child: Column(
        children: _.map((start) {
          return SingleItem(
            weekday: widget.weekday,
            start: start,
            height: _singleHeight,
          );
        }).toList(),
      ),
    );
  }
}

class SingleItem extends StatefulWidget {
  /// `weekday` [String] located weekday
  /// `start`   [String] located col position
  /// `height`  [String] minimum box height
  SingleItem({
    Key key,
    @required this.weekday,
    @required this.start,
    @required this.height,
  }) : super(key: key);

  final weekday;
  final start;
  final height;

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
          'times.indexOf(time) + 1',
        ),
      ),
    );
  }
}
