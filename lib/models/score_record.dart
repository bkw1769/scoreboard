class ScoreRecord {
  final int teamAScore;
  final int teamBScore;
  final String label;
  final String timestamp;
  final String date;

  ScoreRecord({
    required this.teamAScore,
    required this.teamBScore,
    required this.label,
    required this.timestamp,
    required this.date,
  });
}