import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'Thiran_database.db');

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
    await db.execute('''
      CREATE TABLE transaction_responce (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER,
        transaction_description TEXT,
        transaction_status TEXT,
        transaction_time TEXT,
        mail_sent_flag TEXT
      )
    ''');
  }

  Future<void> insertTransactionDetails(List<dynamic> transactions) async {
    final db = await database;

    await db.transaction((txn) async {
      final count = Sqflite.firstIntValue(await txn.rawQuery('SELECT COUNT(*) FROM transaction_responce'));
      if (count == 0) {
        for (var transaction in transactions) {
          await txn.insert(
            'transaction_responce',
            {
              'transaction_id': transaction['id'],
              'transaction_description': transaction['action'],
              'transaction_status': transaction['status'],
              'transaction_time': transaction['dateTime'],
              'mail_sent_flag': 'N',
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchErrorTransactions() async {
    final db = await database;
    return await db.query(
      'transaction_responce',
      where: 'transaction_status = ? and mail_sent_flag = ?',
      whereArgs: ['Error', 'N'],
    );
  }

  Future<void> updateErrorTransactions(List<Map<String, dynamic>> errorTransactions) async {
    final db = await database;

    await db.transaction((txn) async {
      for (var transaction in errorTransactions) {
        String id = transaction['id'].toString();

        await txn.update(
          'transaction_responce',
          {
            'mail_sent_flag': 'Y',
          },
          where: 'transaction_id = ?',
          whereArgs: [id],
        );
      }
    });
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

  Future<List<Map<String, dynamic>>> fetchOfflineLimitData(int pageCount) async {
    final db = await database;

    final offset = (pageCount - 1) * 15;

    return await db.query('github_repositories', limit: 15, offset: offset);
  }
}

final databaseProvider = Provider<SqfliteServices>((ref) {
  return SqfliteServices();
});
