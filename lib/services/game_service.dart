import 'dart:async';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:numbers_game/services/square_model.dart';

class GameService {

  final Random _random = Random();
  final List<SquareModel> squares = [];

  final StreamController<void> _onStateChangedController = new StreamController.broadcast();
  Stream get onStateChanged => _onStateChangedController.stream;

  int _score = 0;
  int _topScore = 0;

  int get score => _score;
  int get topScore => _topScore;

  SharedPreferences _storage;

  GameService() {
    _initService();
  }

  Future<void> _initService() async {
    _storage = await SharedPreferences.getInstance();
    _topScore = _storage.getInt('topScore')?? 0;
    _onStateChangedController.add(null);
  }

  void initNewGame() {
    squares.clear();
    _addRandomSquare();
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void tearDown() {
    _onStateChangedController.close();
  }

  void _addRandomSquare() {
    if (squares.length == 16) {
      _gameLost();
      return;
    }
    final freeCells = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
    squares.forEach((m) => freeCells.remove(m.index));
    final value = _random.nextInt(4) == 3? 4 : 2;
    final index = _random.nextInt(freeCells.length);
    print('added value $value at index $index');
    squares.add(SquareModel(index: index, value: value));
  }

  void _gameLost() {}

  getSquareAtIndex(int index) => squares.firstWhere((m) => m.index == index, orElse: () => null);
}