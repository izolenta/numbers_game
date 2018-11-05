import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SquareModel {

  @required final index;
  @required final int value;
  final bool justAdded;

  int get x => index % 4;
  int get y => index ~/ 4;

  SquareModel({this.index, this.value, this.justAdded: false});

  SquareModel copyWithParams({int index, int value, bool justAdded}) => SquareModel(
    index: index?? this.index,
    value: value?? this.value,
    justAdded: justAdded?? this.justAdded,
  );
}