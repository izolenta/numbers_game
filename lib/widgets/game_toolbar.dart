import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/util/dimension_helper.dart';
import 'package:numbers_game/util/subscriber.dart';
import 'package:numbers_game/widgets/game_button.dart';

class GameToolbar extends StatefulWidget {

  @override
  State<GameToolbar> createState() => _GameToolbarState();
}

class _GameToolbarState extends State<GameToolbar> with SubscriberMixin, DimensionHelper {

  final _gameService = Injector.getInjector().get<GameService>();

  @override
  void initState() {
    subscriptions.add(_gameService.onStateChanged.listen((_) => setState(() {})));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
          left: getPercentFromWidth(context, 5),
          bottom: getPercentFromWidth(context, 2),
        ),
        child: Row(
          children: [
            GameButton(caption: 'score', value: _gameService.score.toString()),
            GameButton(caption: 'top score', value: _gameService.topScore.toString()),
            GameButton(caption: 'restart', onTap: _gameService.initNewGame),
          ]
        )
    );
  }

}
