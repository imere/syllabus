import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './classes.model.dart' show classes;

class Classes extends StatefulWidget {
  Classes({Key key, this.classesHeight}) : super(key: key);

  final classesHeight;

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  var _itemHeight;

  @override
  Widget build(BuildContext context) {
    _itemHeight = widget.classesHeight / classes.length;

    return SizedBox(
      height: widget.classesHeight,
      child: Column(
        children: classes.map((classInfo) {
          return _buildClassItem(name: classInfo.name, height: _itemHeight);
        }).toList(),
      ),
    );
  }
}

SizedBox _buildClassItem({@required String name, @required double height}) {
  return SizedBox(
    height: height,
    child: AutoSizeText(
      name,
      minFontSize: 9,
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
