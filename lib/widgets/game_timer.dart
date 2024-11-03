import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class GameTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimerProvider>(
      builder: (context, timerProvider, child) {
        return Container(
          padding: EdgeInsets.only(top: 18, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이머 디스플레이
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text(
                  timerProvider.displayTime,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 타이머 컨트롤 버튼들
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TimerButton(
                    icon: timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
                    onPressed: () {
                      if (timerProvider.isRunning) {
                        timerProvider.pauseTimer();
                      } else {
                        timerProvider.startTimer();
                      }
                    },
                  ),
                  SizedBox(width: 8),
                  _TimerButton(
                    icon: Icons.refresh,
                    onPressed: timerProvider.resetTimer,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _TimerButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }
}

