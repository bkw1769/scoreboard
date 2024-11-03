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
          return Stack(
            children: [
              // 메인 스코어보드
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => scoreboard.incrementScore(true),
                      child: Container(
                        color: settings.leftColor,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '팀 A',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: settings.leftColor == Colors.black ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    scoreboard.leftScore.toString(),
                                    style: TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: settings.leftColor == Colors.black ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (settings.showSetScore)
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SetScoreDisplay(
                                  isLeft: true,
                                  score: scoreboard.leftSetScore,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => scoreboard.incrementScore(false),
                      child: Container(
                        color: settings.rightColor,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '팀 B',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: settings.rightColor == Colors.white ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    scoreboard.rightScore.toString(),
                                    style: TextStyle(
                                      fontSize: 120,
                                      fontWeight: FontWeight.bold,
                                      color: settings.rightColor == Colors.white ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (settings.showSetScore)
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SetScoreDisplay(
                                  isLeft: false,
                                  score: scoreboard.rightSetScore,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
}
