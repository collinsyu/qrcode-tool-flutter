import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/QrCodeItem.dart';
import 'init.dart';

class QrcodeScanHistory  {
  // static Database? _db;
  //
  // static Future<Database?> getDatabase() async {
  //   if (_db != null) return _db;
  //   _db = await _initDb();
  //   print("创建扫描二维码酷表");
  //   print(_db);
  //
  //   return _db;
  // }
  //
  //
  //
  // static Future<Database> _initDb() async {
  //
  //   return await openDatabase(
  //     // Set the path to the database. Note: Using the `join` function from the
  //     // `path` package is best practice to ensure the path is correctly
  //     // constructed for each platform.
  //     join(await getDatabasesPath(), 'local_database.db'),
  //     // When the database is first created, create a table to store dogs.
  //     onCreate: (db, version) async {
  //       // Run the CREATE TABLE statement on the database.
  //       await db.execute(
  //         'CREATE TABLE SCAN_QRCODE_HISTORY ('
  //             'id INTEGER PRIMARY KEY AUTOINCREMENT,'
  //             'value TEXT,'
  //             'date TEXT,' // 或者使用 'date DATETIME' 如果你需要日期和时间功能
  //             'type TEXT'
  //             ')',
  //       );
  //     },
  //     // Set the version. This executes the onCreate function and provides a
  //     // path to perform database upgrades and downgrades.
  //     version: 1,
  //   );
  // }


  // static const String _dbName = "local_database.db";
  // static const String _tableName = "SCAN_QRCODE_HISTORY";
  // static const String _idColumn = 'id';
  // static const String _valueColumn = 'value';
  // static const String _dateColumn = 'date';
  // static const String _typeColumn = 'type';
  //
  // static Future<Database> get database async {
  //   final dir = await getDatabasesPath();
  //   final path = join(dir, _dbName);
  //   return await openDatabase(path, version: 1, onCreate: _onCreate);
  // }
  //
  // static Future _onCreate(Database db, int version) async {
  //   await db.execute('''
  //     CREATE TABLE IF NOT EXISTS $_tableName (
  //       $_idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
  //       $_valueColumn TEXT NOT NULL,
  //       $_dateColumn TEXT NOT NULL,
  //       $_typeColumn TEXT NOT NULL
  //     )
  //   ''');
  // }

  static getDatabase() async {
    return await DBHelper.database;
  }

  // Define a function that inserts dogs into the database
  static Future<int?> insertQrcode(QrCodeItem data) async {
    // Get a reference to the database.
    final db = await getDatabase();

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    int? newId = await db?.insert(
      'SCAN_QRCODE_HISTORY',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newId;
  }

  // A method that retrieves all the dogs from the dogs table.
  static Future<List<QrCodeItem>> listsQrcode() async {
    // Get a reference to the getDatabase().
    final db = await getDatabase();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db!.query('SCAN_QRCODE_HISTORY');

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return [
      for (final {
      'id': id as int,
      'value': value as String,
      'type': type as String,
      'date': date as String,
      } in dogMaps)
        QrCodeItem(id: id, value: value, type: type, date: date),
    ];
  }

  // 新增方法：根据ID查询QR码详情
  static Future<QrCodeItem?> getQrCodeById(int id) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> result = await db!.query('SCAN_QRCODE_HISTORY', where: 'id = ?', whereArgs: [id]);

    if (result.isEmpty) {
      return null; // 没有找到对应的QR码
    }

    final Map<String, dynamic> firstResult = result.first;
    return QrCodeItem(
      id: firstResult['id'] as int,
      value: firstResult['value'] as String,
      type: firstResult['type'] as String,
      date: firstResult['date'] as String,
    );
  }



  static Future<void> updateQrcode(QrCodeItem data) async {
    // Get a reference to the getDatabase().
    final db = await getDatabase();

    // Update the given Dog.
    await db?.update(
      'SCAN_QRCODE_HISTORY',
      data.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [data.id],
    );
  }

  static Future<void> deleteQrcode(int id) async {
    // Get a reference to the getDatabase().
    final db = await getDatabase();

    // Remove the Dog from the getDatabase().
    await db?.delete(
      'SCAN_QRCODE_HISTORY',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }


}

