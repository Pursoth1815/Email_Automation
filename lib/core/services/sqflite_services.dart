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
    final path = join(databasePath, 'app_database.db');

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

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('github_repositories', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query('github_repositories');
  }
}

final databaseProvider = Provider<SqfliteServices>((ref) {
  return SqfliteServices();
});
