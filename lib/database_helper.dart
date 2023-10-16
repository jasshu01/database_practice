import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  Database? _database;

  Future<void> open() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'my_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
          );
        },
        version: 1,
      );
    }
  }

  Future<int> insert(Map<String, dynamic> data) async {
    await open();
    return await _database!.insert('items', data);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    await open();
    return await _database!.query('items');
  }

  Future<int> update(Map<String, dynamic> data) async {
    await open();
    return await _database!.update('items', data,
        where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<int> delete(int id) async {
    await open();
    return await _database!.delete('items', where: 'id = ?', whereArgs: [id]);
  }

}
