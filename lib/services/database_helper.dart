import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/game_record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('scoreboard.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        gameType TEXT NOT NULL,
        teamAScore INTEGER NOT NULL,
        teamBScore INTEGER NOT NULL,
        teamAName TEXT NOT NULL,
        teamBName TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        additionalData TEXT,
        note TEXT
      )
    ''');

    // 게임 타입 테이블 생성
    await db.execute('''
      CREATE TABLE game_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        settings TEXT
      )
    ''');

    // 기본 게임 타입 추가
    await db.insert('game_types', {
      'name': 'general',
      'description': '일반 경기',
      'settings': json.encode({
        'maxScore': 21,
        'winByTwo': true,
      })
    });
  }

  // 게임 기록 추가
  Future<int> insertGameRecord(GameRecord record) async {
    final db = await instance.database;
    final map = record.toMap();
    map.remove('id');  // autoincrement를 위해 id 제거
    if (map['additionalData'] != null) {
      map['additionalData'] = json.encode(map['additionalData']);
    }
    return await db.insert('game_records', map);
  }

  // 게임 기록 조회 (페이지네이션 지원)
  Future<List<GameRecord>> getGameRecords({
    int? limit,
    int? offset,
    String? gameType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await instance.database;

    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (gameType != null) {
      whereClause += 'gameType = ?';
      whereArgs.add(gameType);
    }

    if (startDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'timestamp >= ?';
      whereArgs.add(startDate.toIso8601String());
    }

    if (endDate != null) {
      if (whereClause.isNotEmpty) whereClause += ' AND ';
      whereClause += 'timestamp <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'game_records',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) {
      var map = maps[i];
      if (map['additionalData'] != null) {
        map['additionalData'] = json.decode(map['additionalData'] as String);
      }
      return GameRecord.fromMap(map);
    });
  }

  // 게임 기록 삭제
  Future<int> deleteGameRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'game_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 특정 기간의 게임 기록 삭제
  Future<int> deleteGameRecordsByDate(DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    return await db.delete(
      'game_records',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
  }

  // 게임 타입별 통계
  Future<Map<String, dynamic>> getGameTypeStats(String gameType) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT 
        COUNT(*) as totalGames,
        AVG(teamAScore) as avgTeamAScore,
        AVG(teamBScore) as avgTeamBScore,
        MAX(teamAScore) as maxTeamAScore,
        MAX(teamBScore) as maxTeamBScore
      FROM game_records
      WHERE gameType = ?
    ''', [gameType]);

    return result.first;
  }
}