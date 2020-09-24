import 'package:app_reminder/models/activity_info.dart';
import 'package:app_reminder/models/category_info.dart';
import 'package:app_reminder/models/notes_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

final String tableActivity = "activities";
final String columnId = "id";
final String columnTitle = "title";
final String columnDate = "activityDateTime";
final String columnPending = "isPending";
final String columnDescription = "description";

final String tableNotes = "notes";
final String tableCategory = "category";
final String tableTask = "task";

class DBHelper {
  static const String DB_NAME = "reminders.db";
  Database _db;
  static DBHelper _dbHelper;

  DBHelper._createInstance();
  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    io.Directory docummentDirectory = await getApplicationDocumentsDirectory();
    String path = join(docummentDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tableActivity($columnId INTEGER PRIMARY KEY, $columnTitle TEXT NOT NULL, $columnDescription TEXT NOT NULL, $columnDate TEXT NOT NULL, $columnPending INTEGER)");
    await db.execute(
        "CREATE TABLE $tableNotes($columnId INTEGER PRIMARY KEY, $columnTitle TEXT NOT NULL, $columnDescription TEXT)");
    await db.execute(
        "CREATE TABLE $tableCategory($columnId INTEGER PRIMARY KEY, $columnTitle TEXT NOT NULL)");
  }

  void insertActivity(ActivityInfo activityInfo) async {
    var dbClient = await this.db;
    var result = await dbClient.insert(tableActivity, activityInfo.toMap());
    print('result : $result');
  }

  Future<List<ActivityInfo>> getAvtivity() async {
    List<ActivityInfo> _activities = [];
    var dbClient = await this.db;
    var result = await dbClient.query(tableActivity);
    result.forEach((element) {
      var activityInfo = ActivityInfo.fromMap(element);
      _activities.add(activityInfo);
    });
    return _activities;
  }

  Future<int> deleteActivity(int id) async {
    var dbClient = await this.db;
    return await dbClient
        .delete(tableActivity, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateActivity(ActivityInfo activityInfo) async {
    var dbClient = await this.db;
    return await dbClient.update(tableActivity, activityInfo.toMap(),
        where: '$columnId = ?', whereArgs: [activityInfo.id]);
  }

  void inserNotes(NotesInfo notesInfo) async {
    var dbClient = await this.db;
    var result = await dbClient.insert(tableNotes, notesInfo.toMap());
    print('result : $result');
  }

  Future<List<NotesInfo>> getNotes() async {
    List<NotesInfo> _notes = [];
    var dbClient = await this.db;
    var result = await dbClient.query(tableNotes);
    result.forEach((element) {
      var notesInfo = NotesInfo.fromMap(element);
      _notes.add(notesInfo);
    });
    return _notes;
  }

  Future<int> deleteNotes(int id) async {
    var dbClient = await this.db;
    return await dbClient
        .delete(tableNotes, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateNotes(NotesInfo notesInfo) async {
    var dbClient = await this.db;
    return await dbClient.update(tableNotes, notesInfo.toMap(),
        where: '$columnId = ?', whereArgs: [notesInfo.id]);
  }

  void insertCategory(CategoryInfo categoryInfo) async {
    var dbClient = await this.db;
    var result = await dbClient.insert(tableCategory, categoryInfo.toMap());
    print('result : $result');
  }

  Future<List<CategoryInfo>> getCategory() async {
    List<CategoryInfo> _categories = [];
    var dbClient = await this.db;
    var result = await dbClient.query(tableCategory);
    result.forEach((element) {
      var categoryInfo = CategoryInfo.fromMap(element);
      _categories.add(categoryInfo);
    });
    return _categories;
  }

  Future<int> deleteCategory(int id) async {
    var dbClient = await this.db;
    return await dbClient
        .delete(tableCategory, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await this.db;
    dbClient.close();
  }
}
