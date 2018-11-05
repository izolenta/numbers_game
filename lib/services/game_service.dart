import 'dart:async';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:numbers_game/services/square_model.dart';

class GameService {

  static const swipeConfig = const [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
  ];

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
    squares.add(SquareModel(index: freeCells[index], value: value));
  }

  void _gameLost() {}

  SquareModel getSquareAtIndex(int index) => squares.firstWhere((m) => m.index == index, orElse: () => null);

  SquareModel getSquareAtCoords(int x, int y) => squares.firstWhere((m) => m.x == x && m.y == y, orElse: () => null);

  void turnUp() {
    for (int i=0; i<4; i++) {
      _moveColumnVertically(i, -1);
    }
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void turnDown() {
    for (int i=0; i<4; i++) {
      _moveColumnVertically(i, 1);
    }
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void turnLeft() {
    for (int i=0; i<4; i++) {
      _moveRowHorizontally(i, -1);
    }
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void turnRight() {
    for (int i=0; i<4; i++) {
      _moveRowHorizontally(i, 1);
    }
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void _moveRowHorizontally(int row, int direction) {
    final cellPositions = direction > 0? [3, 2, 1, 0] : [0, 1, 2, 3];
    bool movePerformed;
    do {
      movePerformed = false;
      for (var x in cellPositions) {
        var model = getSquareAtCoords(x, row);
        if (model != null) {
          var newX = x + direction;
          if (newX >= 0 && newX <= 3) {
            final square = getSquareAtCoords(newX, row);
            if (square == null) {
              squares[squares.indexOf(model)] = new SquareModel(index: model.index + direction, value: model.value);
              movePerformed = true;
            }
            else {
              if (square.value == model.value) {
                squares.remove(model);
                squares[squares.indexOf(square)] = new SquareModel(index: square.index, value: square.value * 2);
                movePerformed = true;
              }
            }
          }
        }
      }
    } while (movePerformed);
  }

  void _moveColumnVertically(int column, int direction) {
    final cellPositions = direction > 0? [3, 2, 1, 0] : [0, 1, 2, 3];
    bool movePerformed;
    do {
      movePerformed = false;
      for (var y in cellPositions) {
        var model = getSquareAtCoords(column, y);
        if (model != null) {
          var newY = y + direction;
          if (newY >= 0 && newY <= 3) {
            final square = getSquareAtCoords(column, newY);
            if (square == null) {
              squares[squares.indexOf(model)] = new SquareModel(index: model.index + direction * 4, value: model.value);
              movePerformed = true;
            }
            else {
              if (square.value == model.value) {
                squares.remove(model);
                squares[squares.indexOf(square)] = new SquareModel(index: square.index, value: square.value * 2);
                movePerformed = true;
              }
            }
          }
        }
      }
    } while (movePerformed);
  }
}