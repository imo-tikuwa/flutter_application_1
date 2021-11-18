import 'dart:async';
import 'dart:io' as io;

import 'models/account.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static late Database _db;

  Future<Database> get db async {
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "database.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE account(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, init_record INTEGER)
    ''');
  }

  Future<int> insertAccount(Account account) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert('INSERT INTO account(name, init_record) VALUES (?, ?)', [account.name, account.initRecord]);
    return res;
  }

  Future<bool> updateAccount(Account account) async {
    var dbClient = await db;
    int res = await dbClient.update("account", account.toMap(), where: "id = ?", whereArgs: <int>[account.id]);
    return res > 0;
  }

  Future<List<Account>> getAccounts() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM account');
    List<Account> accounts = [];
    for (int i = 0; i < list.length; i++) {
      accounts.add(Account(list[i]["id"], list[i]["name"], list[i]["init_record"]));
    }

    return accounts;
  }

  Future<int> deleteAccount(Account account) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete('DELETE FROM account WHERE id = ?', [account.id]);
    return res;
  }

  Account fromAccountMap(Map<String, dynamic> map) {
    return Account(map['id'], map['name'], map['initRecord']);
  }
}