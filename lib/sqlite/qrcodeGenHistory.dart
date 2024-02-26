import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/QrCodeItem.dart';
import 'init.dart';

class QrcodeGenHistory  {
  // static Database? _db;
  //
  // static Future<Database?> getDatabase() async {
  //   if (_db != null) return _db;
  //
  //   _db = await _initDb();
  //   return _db;
  // }
  //
  //
  //
  // static Future<Database> _initDb() async {
  //   final dir = await getDatabasesPath();
  //
  //   return await openDatabase(
  //     // Set the path to the database. Note: Using the `join` function from the
  //     // `path` package is best practice to ensure the path is correctly
  //     // constructed for each platform.
  //     join(await getDatabasesPath(), 'local_database.db'),
  //     // When the database is first created, create a table to store dogs.
  //     onCreate: (db, version) {
  //       // Run the CREATE TABLE statement on the database.
  //       return db.execute(
  //         'CREATE TABLE GEN_QRCODE_HISTORY ('
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
      'GEN_QRCODE_HISTORY',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    db?.close();
    return newId;
  }

  // A method that retrieves all the dogs from the dogs table.
  static Future<List<QrCodeItem>> listsQrcode() async {
    // Get a reference to the getDatabase().
    final db = await getDatabase();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db!.query('GEN_QRCODE_HISTORY');

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
    final List<Map<String, dynamic>> result = await db!.query('GEN_QRCODE_HISTORY', where: 'id = ?', whereArgs: [id]);

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
      'GEN_QRCODE_HISTORY',
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
      'GEN_QRCODE_HISTORY',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
//
// // Create a Dog and add it to the dogs table
// var fido = Dog(
//   id: 0,
//   name: 'Fido',
//   age: 35,
// );
//
// await insertDog(fido);
//
// // Now, use the method above to retrieve all the dogs.
// print(await dogs()); // Prints a list that include Fido.
//
// // Update Fido's age and save it to the getDatabase().
// fido = Dog(
//   id: fido.id,
//   name: fido.name,
//   age: fido.age + 7,
// );
// await updateDog(fido);
//
// // Print the updated results.
// print(await dogs()); // Prints Fido with age 42.
//
// // Delete Fido from the getDatabase().
// await deleteDog(fido.id);
//
// // Print the list of dogs (empty).
// print(await dogs());
}
