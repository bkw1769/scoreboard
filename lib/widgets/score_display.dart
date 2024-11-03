// lib/widgets/score_display.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scoreboard_provider.dart';

class ScoreDisplay extends StatelessWidget {
  final bool isLeft;

  const ScoreDisplay({Key? key, required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreboardProvider>(
      builder: (context, provider, child) {
        final score = isLeft ? provider.leftScore : provider.rightScore;
        final color = isLeft ? provider.leftColor : provider.rightColor;
        final textColor = color == Colors.black ? Colors.white : Colors.black;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              score.toString(),
              style: TextStyle(
                fontSize: provider.fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showColorPicker(BuildContext context, ScoreboardProvider provider, bool isLeft) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final colors = [
          Colors.black,
          Colors.white,
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.purple,
          Colors.orange,
        ];

        return AlertDialog(
          title: Text('색상 선택'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colors.map((color) => GestureDetector(
              onTap: () {
                provider.setColor(isLeft, color);
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            )).toList(),
          ),
        );
      },
    );
  }
}