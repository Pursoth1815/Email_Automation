import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteServices {
  static final SqfliteServices _instance = SqfliteServices._internal();
  factory SqfliteServices() => _instance;
  SqfliteServices._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'Thiran_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE github_repositories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT,
        description TEXT,
        stargazers_count INTEGER,
        avatar_url TEXT,
        user_name TEXT
      )
    ''');
  }

  Future<bool> bulkInsert(List<Map<String, dynamic>> dataList) async {
    final db = await database;

    try {
      final batch = db.batch();
      batch.delete('github_repositories');
      for (var data in dataList) {
        batch.insert('github_repositories', data);
      }
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      print('Error during bulk insert: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchOfflineLimitData(
      int pageCount) async {
    final db = await database;

    final offset = (pageCount - 1) * 15;

    return await db.query('github_repositories', limit: 15, offset: offset);
  }
}

final databaseProvider = Provider<SqfliteServices>((ref) {
  return SqfliteServices();
});
