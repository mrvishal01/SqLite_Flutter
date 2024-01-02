import 'package:hello/notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
  _onCreate(Database db ,int version)async{
      await db.execute(
        "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, age INTEGER NOT NULL, description TEXT NOT NULL, email TEXT)"
      );
  }

  Future<NotesModels> insert(NotesModels notesModels) async{
    var dbClient = await db;
    await dbClient!.insert('notes', notesModels.toMAp());
    return notesModels;
  }

  Future<List<NotesModels>> getNotesList() async{
      var dbClient = await db;
      final List<Map<String, Object?>> queryResult = await dbClient!.query('notes'); 
      return queryResult.map((e) => NotesModels.fromMap(e)).toList();
  }

  Future<int> delete(int id) async{
      var dbClient = await db;
      return await dbClient!.delete(
        'notes', 
        where: 'id = ?',
        whereArgs: [id]
      );
  }

  Future<int> update(NotesModels notesModels) async{
    var dbClient = await db;
    return await dbClient!.update(
      'notes',
      notesModels.toMAp(),
      where: 'id = ?',
      whereArgs: [notesModels.id] 
    );
  }
}
