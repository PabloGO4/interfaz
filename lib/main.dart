import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'database/user_dao.dart';
import 'models/user_model.dart'; // Importar el modelo User

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Demo',
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<User> usuarios = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> users = await UserDao().getUsers();
    setState(() {
      usuarios = users;
    });
  }

  Future<void> _addUser() async {
    User newUser = User(
      nombre: 'Carlos',
      apellido1: 'Rodríguez',
      apellido2: 'Gómez',
      telefono: '654321987',
      dni: '12345678A',
      email: 'carlos@example.com',
      provincia: 'Madrid',
    );
    await UserDao().insertUser(newUser);
    _loadUsers(); // Cargar los usuarios actualizados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addUser,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(usuarios[index].nombre),
            subtitle: Text(usuarios[index].email),
          );
        },
      ),
    );
  }
}
