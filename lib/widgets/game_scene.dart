import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/widgets/game_board.dart';
import 'package:numbers_game/widgets/game_header.dart';
import 'package:numbers_game/widgets/game_toolbar.dart';


class GameScene extends StatefulWidget {
  @override
  State<GameScene> createState() => _GameSceneState();
}

class _GameSceneState extends State<GameScene> with DimensionHelper {

  final GameService _gameService = Injector.getInjector().get<GameService>();

  @override
  void initState() {
    _gameService.initNewGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GameHeader(),
        GameBoard(),
        GameToolbar(),
      ],
    );
  }
}