import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/scoreboard_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('설정'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer3<SettingsProvider, TimerProvider, ScoreboardProvider>(
        builder: (context, settings, timer, scoreboard, child) {
          return ListView(
            children: [
              _buildSection(
                title: '타이머',
                children: [
                  SwitchListTile(
                    title: Text('타이머 표시',
                        style: TextStyle(color: Colors.white)),
                    value: settings.showTimer,
                    onChanged: (value) {
                      settings.toggleTimer();
                      if (!value) timer.resetTimer();
                    },
                    activeColor: Colors.blue,
                  ),
                  SwitchListTile(
                    title: Text('세트 스코어 표시',
                        style: TextStyle(color: Colors.white)),
                    value: settings.showSetScore,
                    onChanged: (value) => settings.toggleSetScore(),
                    activeColor: Colors.blue,
                  ),
                ],
              ),
              _buildSection(
                title: '팀 색상',
                children: [
                  _buildColorPicker(
                    context: context,
                    title: '팀 A 색상',
                    currentColor: settings.leftColor,
                    onColorSelected: (color) => settings.setTeamColor(true, color),
                  ),
                  _buildColorPicker(
                    context: context,
                    title: '팀 B 색상',
                    currentColor: settings.rightColor,
                    onColorSelected: (color) => settings.setTeamColor(false, color),
                  ),
                ],
              ),
              _buildSection(
                title: '기록',
                children: [
                  ListTile(
                    title: Text('기록 보기',
                        style: TextStyle(color: Colors.white)),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () => _showHistory(context, scoreboard),
                  ),
                  ListTile(
                    title: Text('기록 초기화',
                        style: TextStyle(color: Colors.red)),
                    onTap: () => _showClearHistoryDialog(context, scoreboard),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
        Divider(color: Colors.grey[800]),
      ],
    );
  }

  Widget _buildColorPicker({
    required BuildContext context,
    required String title,
    required Color currentColor,
    required Function(Color) onColorSelected,
  }) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: currentColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
      onTap: () => _showColorPickerDialog(
        context,
        title,
        currentColor,
        onColorSelected,
      ),
    );
  }

  void _showColorPickerDialog(
      BuildContext context,
      String title,
      Color currentColor,
      Function(Color) onColorSelected,
      ) {
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: colors.map((color) => GestureDetector(
              onTap: () {
                onColorSelected(color);
                Navigator.pop(context);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: currentColor == color ? 3 : 1,
                  ),
                ),
              ),
            )).toList(),
          ),
        );
      },
    );
  }

  void _showHistory(BuildContext context, ScoreboardProvider scoreboard) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Column(
          children: [
            AppBar(
              backgroundColor: Colors.black,
              title: Text('경기 기록'),
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: scoreboard.scoreHistory.length,
                itemBuilder: (context, index) {
                  final record = scoreboard.scoreHistory[index];
                  return ListTile(
                    title: Text(
                      '팀 A : ${record.teamAScore} / 팀 B : ${record.teamBScore}',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${record.timestamp} ${record.date}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, ScoreboardProvider scoreboard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('기록 초기화'),
          content: Text('모든 경기 기록을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('삭제', style: TextStyle(color: Colors.red)),
              onPressed: () {
                scoreboard.clearHistory();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
