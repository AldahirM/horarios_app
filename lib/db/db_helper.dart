import 'dart:io';

import 'package:horarios_app/models/attendance.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DbHelper {
  static const String _databaseName = 'schedule.db';
  static const _databaseVersion = 1;

  final _attendanceTable = 'attendance';
  DbHelper._();

  static final DbHelper instance = DbHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreateDatabase);
  }

  Future _onCreateDatabase(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE $_attendanceTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
    await batch.commit();
  }
  Future<int> createNewAttendance(Attendance attendance) async {
    Database db = await database;
    return await db.insert(_attendanceTable, attendance.toJsonDB());
  }

  Future<List<Attendance>> getAttendances() async {
    final Database db = await database;
    final List<Map<String, Object?>> respDb = await db.query(_attendanceTable);
    return respDb.map((e) => Attendance(
      id: e['id'] as int,
      type: e['type'] as String,
      date: DateTime.parse(e['date'] as String),
    )).toList();
  }

  Future<int> deleteAttendance(int id) async {
    Database db = await database;
    return await db.delete(_attendanceTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateAttendance(Attendance attendance) async {
    Database db = await database;
    return await db.update(
      _attendanceTable,
      attendance.toJsonDB(),
      where: 'id = ?',
      whereArgs: [attendance.id],
    );
  }

  Future<List<Attendance>> getTodayAttendances(DateTime date) async {
    final Database db = await database;
    final String todayStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD

    final List<Map<String, Object?>> respDb = await db.query(
      _attendanceTable,
      where: 'date LIKE ?',
      whereArgs: ['$todayStr%'],
    );

    return respDb.map((e) => Attendance(
      id: e['id'] as int,
      type: e['type'] as String,
      date: DateTime.parse(e['date'] as String),
    )).toList();
  }

  Future<void> deleteAllData() async {
    Database db = await database;
    await db.rawDelete('DELETE FROM $_attendanceTable');
  }


}