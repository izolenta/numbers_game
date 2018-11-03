import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/util/subscriber.dart';


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

    return Stack(
      children: boardWidgets,
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

    result.add(Padding(
      padding: EdgeInsets.only(left: sideGap),
      child:  Container(
        width: getPercentFromWidth(context, 90),
        height: getPercentFromWidth(context, 90),
        decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.all(Radius.circular(boardRadius))
        ),
      )),
    );

    final squares = <Widget>[];

    for (var i=0; i<16; i++) {
      final x = i % 4;
      final y = i ~/ 4;
      squares.add(Positioned(
        top: cellGap + (y * cellSize * cellGap),
        left: cellGap + (x * cellSize * cellGap),
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(color: Colors.tealAccent, borderRadius: BorderRadius.all(Radius.circular(boardRadius))),
        ),
      ));
    }

    final stack = Stack(children: squares);
    result.add(stack);
    return result;
  }
}