import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numbers_game/services/game_service.dart';
import 'package:numbers_game/widgets/game_scene.dart';
import 'package:screen/screen.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

void main() {

  final injector = Injector.getInjector();

  injector.map<GameService>((s) =>  GameService(), isSingleton: true);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Screen.keepOn(true);
    return new MaterialApp(
      title: '2048 game',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('2048 game for DartUP!'),
        ),
        body: GameScene(),
      ),
    );
  }
}