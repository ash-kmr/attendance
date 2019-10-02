import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'course.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Courses ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "course_name TEXT UNIQUE"
          ");");
      await db.execute("create table Attendances("
      "id integer primary key,"
      "course_id integer,"
      "attendance_date date,"
      "attended integer,"
      "foreign key (course_id) references Courses(id)"
      ");");
    });
  }
  
  newCourse(courseName) async {
    final db = await database;
    var res = await db.rawInsert(
      "INSERT Into Courses (course_name)"
      " VALUES ('${courseName}')");
    return res;
  }

  getAllCourses() async {
    final db = await database;
    var res =await db.query("Courses");
    List<Course> list = res.map((c) => Course.fromJson(c)).toList();
    // List<Course> list = res.isEmpty ? res.map((c) => Course.fromJson(c)).toList() : [];
    print(list);
    return list;
  }
}