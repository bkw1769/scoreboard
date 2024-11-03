class GameRecord {
  final int? id;
  final String gameType;  // 'basketball', 'volleyball', 'pingpong' 등
  final int teamAScore;
  final int teamBScore;
  final String teamAName;
  final String teamBName;
  final DateTime timestamp;
  final Map<String, dynamic>? additionalData;  // 추가 데이터를 위한 유연한 필드
  final String? note;

  GameRecord({
    this.id,
    required this.gameType,
    required this.teamAScore,
    required this.teamBScore,
    required this.teamAName,
    required this.teamBName,
    required this.timestamp,
    this.additionalData,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gameType': gameType,
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'teamAName': teamAName,
      'teamBName': teamBName,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData != null ?
      Map<String, dynamic>.from(additionalData!) : null,
      'note': note,
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      id: map['id'] as int?,
      gameType: map['gameType'] as String,
      teamAScore: map['teamAScore'] as int,
      teamBScore: map['teamBScore'] as int,
      teamAName: map['teamAName'] as String,
      teamBName: map['teamBName'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      additionalData: map['additionalData'] != null ?
      Map<String, dynamic>.from(map['additionalData']) : null,
      note: map['note'] as String?,
    );
  }
}
