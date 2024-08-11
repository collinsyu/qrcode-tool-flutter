import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper  {

  static Future<Database> get database async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'local_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    try {
      print('===========================================');
      print('Creating QRCODE_SCAN_HISTORY table...');
      await db.execute(
          'CREATE TABLE If NOT EXISTS SCAN_QRCODE_HISTORY ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'value TEXT,'
              'format INTEGER,'
              'date TEXT,' // 或者使用 'date DATETIME' 如果你需要日期和时间功能
              'type TEXT'
              ')'
      );

      print('Creating QRCODE_GEN_HISTORY table...');
      await db.execute(
          'CREATE TABLE If NOT EXISTS GEN_QRCODE_HISTORY ('
              'id INTEGER PRIMARY KEY AUTOINCREMENT,'
              'value TEXT,'
              'format INTEGER,'
              'date TEXT,' // 或者使用 'date DATETIME' 如果你需要日期和时间功能
              'type TEXT'
              ')'
      );

      print('Tables created successfully.');
    } catch (exception,stackTrace) {
      print('An error occurred: $exception');
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }





}

