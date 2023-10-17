import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  Database? _database;

  Future<void> open() async {
    try {
      if (_database == null) {
        _database = await openDatabase(
          join(await getDatabasesPath(), 'my_database.db'),
          onCreate: (db, version) {
            db.execute(
              'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT, description TEXT)',
            );
            db.execute(
              'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT PRIMARY KEY, password TEXT)',
            );
            return;
          },
          version: 3,
        );
      }
    } catch (e) {
      print("Error while opening the database: $e");
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
    return await _database!
        .update('items', data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<int> delete(int id) async {
    await open();
    return await _database!.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  // Future<int> addUser(Map<String, dynamic> data) async {
  //   await open();
  //   return await _database!.insert('users', data);
  // }
  Future<void> addUser(Map<String, dynamic> user) async {
    await open(); // Ensure that the database is open.

    try {
      // Insert the user into the 'users' table.
      await _database!.insert('users', user);
      print('User added to the database: ${user['email']}');
    } catch (e) {
      print('Error adding user to the database: $e');
    }
  }

  Future<int> updateUser(Map<String, dynamic> data) async {
    await open();
    return await _database!
        .update('users', data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<int> deleteUser(int id) async {
    await open();
    return await _database!.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> findUser(Map<String, dynamic> user) async {
    await open(); // Ensure that the database is open.


    List<Map<String, dynamic>> results = await _database!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [user['email'], user['password']],
    );

    if (results.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
