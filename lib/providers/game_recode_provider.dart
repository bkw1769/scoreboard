import 'package:flutter/foundation.dart';
import '../services/database_helper.dart';
import '../models/game_record.dart';

class GameRecordProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<GameRecord> _records = [];
  bool _isLoading = false;
  String _currentGameType = 'general';

  List<GameRecord> get records => _records;
  bool get isLoading => _isLoading;
  String get currentGameType => _currentGameType;

  Future<void> loadRecords({
    String? gameType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await _db.getGameRecords(
        gameType: gameType,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        offset: offset,
      );
    } catch (e) {
      print('Error loading records: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(GameRecord record) async {
    try {
      await _db.insertGameRecord(record);
      await loadRecords(gameType: _currentGameType);
    } catch (e) {
      print('Error adding record: $e');
    }
  }

  Future<void> deleteRecord(int id) async {
    try {
      await _db.deleteGameRecord(id);
      await loadRecords(gameType: _currentGameType);
    } catch (e) {
      print('Error deleting record: $e');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    return await _db.getGameTypeStats(_currentGameType);
  }

  void setGameType(String gameType) {
    _currentGameType = gameType;
    loadRecords(gameType: gameType);
  }
}
