import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart'; // Importamos DatabaseHelper desde la carpeta database
import '../models/user_model.dart'; // Importamos User desde la carpeta models

class UserDao {
  // Insertar un nuevo usuario
  Future<void> insertUser(User user) async {
    final db = await DatabaseHelper().database;
    await db.insert('usuarios', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Obtener todos los usuarios
  Future<List<User>> getUsers() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Obtener un usuario por su ID
  Future<User?> getUserById(int id) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Actualizar un usuario
  Future<int> updateUser(User user) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'usuarios',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Eliminar un usuario
  Future<void> deleteUser(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
