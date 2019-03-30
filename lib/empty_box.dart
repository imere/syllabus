import 'package:flutter/material.dart';

class EmptyBox extends StatefulWidget {
  /// Is located at column [weekday] and row [start],
  /// span [step] rows which height is [minHeight]
  EmptyBox({
    Key key,
    @required this.weekday,
    @required this.start,
    @required this.step,
    @required this.minHeight,
  }) : super(key: key);

  final int weekday;
  final int start;
  final int step;
  final double minHeight;

  @override
  _EmptyBoxState createState() => _EmptyBoxState();
}

class _EmptyBoxState extends State<EmptyBox> {
  @override
  Widget build(BuildContext context) {
    var start = widget.start;
    var step = widget.step;

    /// Build [EmptyBox] to fill the one column from `start` semantically in order
    var _ = List.generate(step, (idx) => start++);

    return SizedBox(
      height: widget.minHeight * step,
      child: Column(
        children: _.map((start) {
          return SingleItem(
            key: Key('$start'),
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
  /// Located at column [weekday] where row
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
    return Container(
      width: double.infinity,
      height: widget.height,
    );
  }
}
