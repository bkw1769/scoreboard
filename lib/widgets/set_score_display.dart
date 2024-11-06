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
        color: Colors.black,  // 배경색 검정
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(isLeft ? 10 : 0), // 오른쪽 상단만 둥글게
          topLeft: Radius.circular(isLeft ? 0 : 10), // 왼쪽 상단만 둥글게
        ),
      ),
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
