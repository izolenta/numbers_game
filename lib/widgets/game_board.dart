import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/util/subscriber.dart';
import 'package:swipedetector/swipedetector.dart';

class GameBoard extends StatefulWidget {
  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> with DimensionHelper, SubscriberMixin {

  final GameService _gameService = Injector.getInjector().get<GameService>();

  @override
  void initState() {
    subscriptions.add(_gameService.onStateChanged.listen((_) => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final boardWidgets = _createBoardWidgets();

    return SwipeDetector(
      child: Stack(children: boardWidgets),
      onSwipeUp: _gameService.turnUp,
      onSwipeDown: _gameService.turnDown,
      onSwipeLeft: _gameService.turnLeft,
      onSwipeRight: _gameService.turnRight,
      swipeConfiguration: SwipeConfiguration(
        horizontalSwipeMinDisplacement: 30.0,
        verticalSwipeMinDisplacement: 30.0,
      ),
    );
  }

  @override
  void dispose() {
    cancelSubscriptions();
    super.dispose();
  }

  List<Widget> _createBoardWidgets() {

    final sideGap = getPercentFromWidth(context, 5);
    final cellGap = getPercentFromWidth(context, 2);
    final cellSize = getPercentFromWidth(context, 20);
    final boardRadius = cellGap;

    final result = <Widget>[];

    final squares = <Widget>[];

    for (var i=0; i<16; i++) {
      final x = i % 4;
      final y = i ~/ 4;
      squares.add(Positioned(
        top: cellGap + (y * (cellSize + cellGap)),
        left: cellGap + (x * (cellSize + cellGap)),
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(color: _getColor(0), borderRadius: BorderRadius.all(Radius.circular(boardRadius))),
        ),
      ));
    }

    for (var model in _gameService.squares) {
      squares.add(Positioned(
        top: cellGap + (model.y * (cellSize + cellGap)),
        left: cellGap + (model.x * (cellSize + cellGap)),
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(color: _getColor(model.value), borderRadius: BorderRadius.all(Radius.circular(boardRadius))),
          child: Center(child: Text(model.value.toString(), style: TextStyle(color: Colors.white, fontSize: 48 * getFactor(context))))
        ),
      ));
    }

    final stack = Stack(children: squares);

    final container = Container(
      width: getPercentFromWidth(context, 90),
      height: getPercentFromWidth(context, 90),
      child: stack,
      decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.all(Radius.circular(boardRadius))
      ),
    );

    result.add(Padding(
      padding: EdgeInsets.only(left: sideGap),
      child: container),
    );

    return result;
  }

  static const _colors = [
    Colors.tealAccent,
    Colors.lightBlueAccent,
    Colors.lightBlue,
    Colors.blue,
    Colors.lime,
    Colors.amber,
    Colors.redAccent,
    Colors.red,
    Colors.deepOrange,
    Colors.purpleAccent,
    Colors.purple,
    Colors.deepPurple,
  ];

  Color _getColor(int number) {
    if (number == 0) {
      return _colors[0];
    }
    return _colors[sqrt(number).floor()];
  }
}