import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _showTimer = false;
  bool _showSetScore = true;  // 세트 스코어 표시 여부
  Color _leftColor = Colors.grey;
  Color _rightColor = Colors.white;

  bool get showTimer => _showTimer;
  bool get showSetScore => _showSetScore;
  Color get leftColor => _leftColor;
  Color get rightColor => _rightColor;

  void toggleTimer() {
    _showTimer = !_showTimer;
    notifyListeners();
  }

  void toggleSetScore() {
    _showSetScore = !_showSetScore;
    notifyListeners();
  }

  void setTeamColor(bool isLeft, Color color) {
    if (isLeft) {
      _leftColor = color;
    } else {
      _rightColor = color;
    }
    notifyListeners();
  }
}

