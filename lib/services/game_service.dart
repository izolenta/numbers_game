import 'dart:async';
import 'dart:math';

import 'package:numbers_game/util/direction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numbers_game/services/square_model.dart';
import 'package:collection/collection.dart';

class GameService {

  Function eq = const ListEquality().equals;

  var transformFunc = <List<TransformFunction>>[
    [null, null],
    [_turnCounterClockwise, _turnClockwise],
    [_turnHalfWay, _turnHalfWay],
    [_turnClockwise, _turnCounterClockwise],
  ];

  final Random _random = Random();
  final List<SquareModel> squares = [];

  final StreamController<void> _onStateChangedController = new StreamController.broadcast();
  Stream get onStateChanged => _onStateChangedController.stream;

  int _score = 0;
  int _topScore = 0;

  int get score => _score;
  int get topScore => _topScore;

  GameState _state;

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
    _score = 0;
    _state = GameState.inProgress;
    _addRandomSquare();
    _addRandomSquare();
    _onStateChangedController.add(null);
  }

  void tearDown() {
    _onStateChangedController.close();
  }

  void _addRandomSquare() {
    _checkWinGame();
    final freeCells = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
    squares.forEach((m) => freeCells.remove(m.index));
    final value = _random.nextInt(4) == 3? 4 : 2;
    final index = _random.nextInt(freeCells.length);
    squares.add(SquareModel(index: freeCells[index], value: value, justAdded: true));
    _checkLoseGame();
  }

  void _checkWinGame() {
    if (squares.firstWhere((m) => m.value == 2048, orElse: () => null) != null) {
      _state = GameState.won;
      print("WON!");
      _onStateChangedController.add(null);
    }
  }

  void _checkLoseGame() {
    if (squares.length == 16) {
      for (int i=0; i<16; i++) {
        final model = _findSquareAt(squares, i % 4, i ~/ 4);
        if (model.x > 0 && _findSquareAt(squares, model.x-1, model.y).value == model.value) return;
        if (model.x < 3 && _findSquareAt(squares, model.x+1, model.y).value == model.value) return;
        if (model.y > 0 && _findSquareAt(squares, model.x, model.y-1).value == model.value) return;
        if (model.y < 3 && _findSquareAt(squares, model.x, model.y+1).value == model.value) return;
      }
      _state = GameState.lost;
      print("LOST!");
      _onStateChangedController.add(null);
    }
  }

  void turn(Direction direction) {
    if (_state == GameState.inProgress) {
      _rotateBoard(transformFunc[direction.value].first);
      final result = _moveRowLeft(squares);
      if (!eq(squares, result)) {
        squares.replaceRange(0, squares.length, result);
        _rotateBoard(transformFunc[direction.value].last);
        _addRandomSquare();
      }
      else {
        _rotateBoard(transformFunc[direction.value].last);
      }
      _onStateChangedController.add(null);
    }
  }

  List<SquareModel>_moveRowLeft(List<SquareModel> squareModel) {
    final newSquareModel = List<SquareModel>.from(squareModel);
    for (int i=0; i<4; i++) {
      bool movePerformed;
      do {
        movePerformed = false;
        for (var x = 0; x<4; x++ ) {
          var model = _findSquareAt(newSquareModel, x, i);
          if (model != null) {
            var newX = x - 1;
            if (newX >= 0 && newX <= 3) {
              final square = _findSquareAt(newSquareModel, newX, i);
              if (square == null) {
                newSquareModel[newSquareModel.indexOf(model)] = new SquareModel(index: model.index - 1, value: model.value);
                movePerformed = true;
              }
              else {
                if (square.value == model.value) {
                  newSquareModel.remove(model);
                  newSquareModel[newSquareModel.indexOf(square)] = new SquareModel(index: square.index, value: square.value * 2);
                  movePerformed = true;
                  _updateScore(square.value * 2);
                }
              }
            }
          }
        }
      } while (movePerformed);
    }
    return newSquareModel;
  }

  void _updateScore(int addition) {
    _score += addition;
    if (_topScore < score) {
      _topScore = score;
      _storage.setInt('topScore', topScore);
    }
  }

  static SquareModel _turnCounterClockwise(SquareModel model) => model.copyWithParams(index: (3-model.x) * 4 + model.y);
  static SquareModel _turnClockwise(SquareModel model) => model.copyWithParams(index: model.x * 4 + (3 - model.y));
  static SquareModel _turnHalfWay(SquareModel model) => model.copyWithParams(index: (3 - model.x) + (3 - model.y) * 4);

  void _rotateBoard(TransformFunction func) {
    if (func != null) {
      for (int i = 0; i < squares.length; i++)
        squares[i] = func(squares[i]);
    }
  }

  SquareModel _findSquareAt(List<SquareModel> sqModel, int x, int y) => sqModel.firstWhere((m) => m.x == x && m.y == y, orElse: () => null);

}

typedef TransformFunction = SquareModel Function(SquareModel model);

enum GameState {
  inProgress, won, lost
}