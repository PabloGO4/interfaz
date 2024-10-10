class User {
  int? id;
  String nombre;
  String apellido1;
  String apellido2;
  String telefono;
  String dni;
  String email;
  String provincia;

  // Constructor
  User({
    this.id,
    required this.nombre,
    required this.apellido1,
    required this.apellido2,
    required this.telefono,
    required this.dni,
    required this.email,
    required this.provincia,
  });

  // Convertir un objeto User a un Map (para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'telefono': telefono,
      'dni': dni,
      'email': email,
      'provincia': provincia,
    };
  }

  // Crear un objeto User a partir de un Map (proveniente de SQLite)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nombre: map['nombre'],
      apellido1: map['apellido1'],
      apellido2: map['apellido2'],
      telefono: map['telefono'],
      dni: map['dni'],
      email: map['email'],
      provincia: map['provincia'],
    );
  }
}
