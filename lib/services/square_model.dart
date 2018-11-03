import 'package:meta/meta.dart';

class SquareModel {
  @required final index;
  @required final int value;

  int get x => index % 4;
  int get y => index ~/ 4;

  SquareModel({this.index, this.value});
}