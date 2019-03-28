import 'package:flutter/material.dart';

class EmptyModel {
  EmptyModel({
    @required this.minHeight,
    @required this.weekday,
    @required this.start,
    @required this.count,
  })  : assert(null != minHeight),
        assert(null != weekday),
        assert(null != start),
        assert(null != count);

  final double minHeight;
  final int weekday;
  final int start;
  final int count;
}
