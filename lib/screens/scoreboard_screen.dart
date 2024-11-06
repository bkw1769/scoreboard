import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard/screens/settings_screen.dart';
import '../providers/scoreboard_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/game_timer.dart';
import '../widgets/score_display.dart';
import '../widgets/set_score_display.dart';

class ScoreboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer3<ScoreboardProvider, TimerProvider, SettingsProvider>(
        builder: (context, scoreboard, timer, settings, child) {
          // 현재 위치에 따른 팀 스코어 결정
          final leftScore = settings.isCourtReversed ?
          scoreboard.rightScore : scoreboard.leftScore;
          final rightScore = settings.isCourtReversed ?
          scoreboard.leftScore : scoreboard.rightScore;
          final leftSetScore = settings.isCourtReversed ?
          scoreboard.rightSetScore : scoreboard.leftSetScore;
          final rightSetScore = settings.isCourtReversed ?
          scoreboard.leftSetScore : scoreboard.rightSetScore;

          return Stack(
            children: [
              // 메인 스코어보드
              Row(
                children: [
                  Expanded(
                    child: _buildScorePanel(
                      context: context,
                      score: leftScore,
                      setScore: leftSetScore,
                      isLeft: true,
                      teamName: settings.isCourtReversed ? '팀 B' : '팀 A',
                      backgroundColor: settings.leftColor,
                      onScoreChange: (int delta) {
                        scoreboard.changeScore(!settings.isCourtReversed, delta);
                      },
                      settings: settings,
                    ),
                  ),
                  Expanded(
                    child: _buildScorePanel(
                      context: context,
                      score: rightScore,
                      setScore: rightSetScore,
                      isLeft: false,
                      teamName: settings.isCourtReversed ? '팀 A' : '팀 B',
                      backgroundColor: settings.rightColor,
                      onScoreChange: (int delta) {
                        scoreboard.changeScore(settings.isCourtReversed, delta);
                      },
                      settings: settings,
                    ),
                  ),
                ],
              ),

              // 코트 체인지 버튼
              Positioned(
                top: 10,
                left: 10,
                child:IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                  onPressed: settings.toggleCourtPosition,
                  tooltip: '코트 체인지',
                ),
              ),

              // 타이머
              if (settings.showTimer)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GameTimer(),
                  ),
                ),

              // 설정 버튼
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.grey),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsScreen()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScorePanel({
    required BuildContext context,
    required int score,
    required int setScore,
    required bool isLeft,
    required String teamName,
    required Color backgroundColor,
    required Function(int) onScoreChange,
    required SettingsProvider settings,
  }) {
    return Container(
      color: backgroundColor,
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          final velocity = details.velocity.pixelsPerSecond.dy;
          if (velocity.abs() > 100) {  // 최소 속도 임계값
            if (velocity > 0) {  // 아래로 슬라이드
              onScoreChange(-1);
            } else {  // 위로 슬라이드
              onScoreChange(1);
            }
          }
        },
        onVerticalDragUpdate: (details) {
          // 드래그 중에 시각적 피드백을 위한 로직 추가 가능
        },
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    teamName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor == Colors.black ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      color: backgroundColor == Colors.black ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (settings.showSetScore)
              Container(
                alignment: isLeft ? Alignment.bottomLeft : Alignment.bottomRight,
                child: SetScoreDisplay(
                  isLeft: isLeft,
                  score: setScore,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
