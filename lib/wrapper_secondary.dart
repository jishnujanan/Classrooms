import 'package:classrooms_tkmce/screens/classes.dart';
import 'package:classrooms_tkmce/screens/classroom.dart';
import 'package:flutter/material.dart';

class SecondWrapper extends StatefulWidget {
  int? joined;
  String? code;
  SecondWrapper({this.code, this.joined});
  @override
  _SecondWrapperState createState() => _SecondWrapperState();
}

class _SecondWrapperState extends State<SecondWrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.joined == 1
        ? ClassRoom(
            code: widget.code,
          )
        : Classes();
  }
}
