import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _showTimer = false;
  bool _showSetScore = true;  // 세트 스코어 표시 여부
  Color _leftColor = Colors.grey;
  Color _rightColor = Colors.white;
  bool _isCourtReversed = false;  // 코트 위치 상태 추가

  bool get showTimer => _showTimer;
  bool get showSetScore => _showSetScore;
  Color get leftColor => _leftColor;
  Color get rightColor => _rightColor;
  bool get isCourtReversed => _isCourtReversed;

  // 팀 A의 실제 색상 (위치에 따라)
  Color get teamAColor => _isCourtReversed ? _rightColor : _leftColor;
  // 팀 B의 실제 색상 (위치에 따라)
  Color get teamBColor => _isCourtReversed ? _leftColor : _rightColor;

  void toggleTimer() {
    _showTimer = !_showTimer;
    notifyListeners();
  }

  void toggleSetScore() {
    _showSetScore = !_showSetScore;
    notifyListeners();
  }

  void toggleCourtPosition() {
    _isCourtReversed = !_isCourtReversed;
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

