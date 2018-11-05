import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SquareModel {

  @required final index;
  @required final int value;
  final bool justAdded;

  int get x => index % 4;
  int get y => index ~/ 4;

  SquareModel({this.index, this.value, this.justAdded: false});
}