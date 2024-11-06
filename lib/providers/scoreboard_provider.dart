import 'package:flutter/material.dart';
import '../models/score_record.dart';

class ScoreboardProvider with ChangeNotifier {
  int _leftScore = 0;
  int _rightScore = 0;
  int _leftSetScore = 0;
  int _rightSetScore = 0;
  int _maxScore = 21;
  double _fontSize = 100;
  Color _leftColor = Colors.black;
  Color _rightColor = Colors.white;
  bool _showTimer = false;
  List<ScoreRecord> _scoreHistory = [];

  // Getters
  int get leftScore => _leftScore;
  int get rightScore => _rightScore;
  int get leftSetScore => _leftSetScore;
  int get rightSetScore => _rightSetScore;
  int get maxScore => _maxScore;
  double get fontSize => _fontSize;
  Color get leftColor => _leftColor;
  Color get rightColor => _rightColor;
  bool get showTimer => _showTimer;
  List<ScoreRecord> get scoreHistory => _scoreHistory;

  void incrementScore(bool isLeft) {
    if (isLeft) {
      _leftScore++;
    } else {
      _rightScore++;
    }
    _checkSetWin();
    notifyListeners();
    changeScore(isLeft, 1);
  }

  void decrementScore(bool isLeft) {
    if (isLeft && _leftScore > 0) {
      _leftScore--;
    } else if (!isLeft && _rightScore > 0) {
      _rightScore--;
    }
    notifyListeners();
  }

  void _checkSetWin() {
    if (_leftScore >= _maxScore && _leftScore - _rightScore >= 2) {
      _leftSetScore++;
      _resetGameScore();
    } else if (_rightScore >= _maxScore && _rightScore - _leftScore >= 2) {
      _rightSetScore++;
      _resetGameScore();
    }
  }

  void _resetGameScore() {
    _leftScore = 0;
    _rightScore = 0;
    notifyListeners();
  }

  void resetAllScores() {
    _leftScore = 0;
    _rightScore = 0;
    _leftSetScore = 0;
    _rightSetScore = 0;
    notifyListeners();
  }

  void setColor(bool isLeft, Color color) {
    if (isLeft) {
      _leftColor = color;
    } else {
      _rightColor = color;
    }
    notifyListeners();
  }

  void toggleTimer() {
    _showTimer = !_showTimer;
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void addToHistory(String label) {
    final now = DateTime.now();
    _scoreHistory.add(ScoreRecord(
      teamAScore: _leftScore,
      teamBScore: _rightScore,
      label: label,
      timestamp: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      date: '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}',
    ));
    notifyListeners();
  }

  void changeScore(bool isLeft, int delta) {
    if (isLeft) {
      _leftScore = (_leftScore + delta).clamp(0, 99);  // 0-99 범위로 제한
    } else {
      _rightScore = (_rightScore + delta).clamp(0, 99);
    }
    _checkSetWin();  // 승리 조건 체크
    notifyListeners();
  }

  void clearHistory() {
    _scoreHistory.clear();
    notifyListeners();
  }
}