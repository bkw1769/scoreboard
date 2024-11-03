import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SetScoreDisplay extends StatelessWidget {
  final bool isLeft;
  final int score;

  const SetScoreDisplay({
    Key? key,
    required this.isLeft,
    required this.score,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
