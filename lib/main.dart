import 'package:flutter/material.dart';
import 'database/user_dao.dart'; // Importar tu DAO
import 'models/user_model.dart'; // Importar el modelo User

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Usuarios',
      home: HomeScreen(),
    );
  }
}

// Pantalla de Inicio con las opciones
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú Principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(context, 'Listar Base de Datos', ListUsersScreen()),
            SizedBox(height: 20),
            _buildMenuButton(context, 'Crear Usuario', CreateUserScreen()),
            SizedBox(height: 20),
            _buildMenuButton(context, 'Eliminar Usuario', DeleteUserScreen()),
            SizedBox(height: 20),
            _buildMenuButton(context, 'Modificar Usuario', UpdateUserScreen()),
            SizedBox(height: 20),
            _buildMenuButton(context, 'Consultas', QueryScreen()),
          ],
        ),
      ),
    );
  }

  // Botones centrados y del mismo tamaño
  Widget _buildMenuButton(BuildContext context, String label, Widget screen) {
    return Center(
      child: SizedBox(
        width: double.infinity, // Hacer que los botones ocupen todo el ancho
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
          },
          child: Text(label),
        ),
      ),
    );
  }
}

// Pantalla para Crear Usuario
class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellido1Controller = TextEditingController();
  final TextEditingController _apellido2Controller = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _provinciaSeleccionada;
  List<String> provincias = [
    'Álava', 'Albacete', 'Alicante', 'Almería', 'Asturias', 'Ávila', 'Badajoz', 
    'Barcelona', 'Burgos', 'Cáceres', 'Cádiz', 'Cantabria', 'Castellón', 'Ciudad Real', 
    'Córdoba', 'Cuenca', 'Gerona', 'Granada', 'Guadalajara', 'Guipúzcoa', 'Huelva', 
    'Huesca', 'Islas Baleares', 'Jaén', 'La Coruña', 'La Rioja', 'Las Palmas', 'León', 
    'Lérida', 'Lugo', 'Madrid', 'Málaga', 'Murcia', 'Navarra', 'Orense', 'Palencia', 
    'Pontevedra', 'Salamanca', 'Segovia', 'Sevilla', 'Soria', 'Tarragona', 
    'Santa Cruz de Tenerife', 'Teruel', 'Toledo', 'Valencia', 'Valladolid', 'Vizcaya', 
    'Zamora', 'Zaragoza'
  ];

  // Función para guardar el usuario
  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      User newUser = User(
        nombre: _nombreController.text,
        apellido1: _apellido1Controller.text,
        apellido2: _apellido2Controller.text,
        telefono: _telefonoController.text,
        dni: _dniController.text,
        email: _emailController.text,
        provincia: _provinciaSeleccionada!,
      );

      // Insertar el usuario en la base de datos usando UserDao
      await UserDao().insertUser(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario guardado con éxito')),
      );

      // Limpiar los campos del formulario
      _nombreController.clear();
      _apellido1Controller.clear();
      _apellido2Controller.clear();
      _telefonoController.clear();
      _dniController.clear();
      _emailController.clear();
      setState(() {
        _provinciaSeleccionada = null;
      });
    }
  }

  void _clearFields() {
    _nombreController.clear();
    _apellido1Controller.clear();
    _apellido2Controller.clear();
    _telefonoController.clear();
    _dniController.clear();
    _emailController.clear();
    setState(() {
      _provinciaSeleccionada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextFormField(
                controller: _apellido1Controller,
                decoration: InputDecoration(labelText: 'Primer Apellido'),
              ),
              TextFormField(
                controller: _apellido2Controller,
                decoration: InputDecoration(labelText: 'Segundo Apellido'),
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextFormField(
                controller: _dniController,
                decoration: InputDecoration(labelText: 'DNI'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
              ),
              DropdownButtonFormField<String>(
                value: _provinciaSeleccionada,
                items: provincias.map((String provincia) {
                  return DropdownMenuItem<String>(
                    value: provincia,
                    child: Text(provincia),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _provinciaSeleccionada = newValue;
                  });
                },
                decoration: InputDecoration(labelText: 'Provincia'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _clearFields,
                    child: Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saveUser,
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla para listar usuarios
class ListUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listar Usuarios')),
      body: Center(child: Text('Aquí se listarán los usuarios')),
    );
  }
}

// Pantalla para eliminar usuarios
class DeleteUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eliminar Usuario')),
      body: Center(child: Text('Aquí se eliminará un usuario')),
    );
  }
}

// Pantalla para modificar usuarios
class UpdateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modificar Usuario')),
      body: Center(child: Text('Aquí se modificará un usuario')),
    );
  }
}

// Pantalla para consultas (placeholder)
class QueryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultas')),
      body: Center(child: Text('Aquí se realizarán consultas')),
    );
  }
}
