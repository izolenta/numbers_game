import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/util/dimension_helper.dart';


class GameHeader extends StatefulWidget {
  @override
  State<GameHeader> createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> with DimensionHelper {

  final GameService _gameService = Injector.getInjector().get<GameService>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: Column [
        GameHeader(),
        GameToolbar(),
        GameBoard(),
        GameHint(),
      ],
    );
  }
}