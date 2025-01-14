import 'package:flutter/material.dart';
import 'package:drink_map/crear_cuenta.dart';
import 'package:drink_map/listado.dart'; // Asegúrate de importar la pantalla de registro
import 'dart:convert'; // Para convertir el JSON a Map
import 'dart:io'; // Para manipular archivos
import 'package:path_provider/path_provider.dart'; // Para obtener el directorio de documentos

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Función para leer los datos del archivo JSON
  Future<List<dynamic>> _loadUsers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/users.json';
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return jsonDecode(jsonString); // Devuelve la lista de usuarios
      } else {
        return []; // Si el archivo no existe, retorna una lista vacía
      }
    } catch (e) {
      print('Error al cargar usuarios: $e');
      return [];
    }
  }

  void _onContinue(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Mostrar un mensaje si los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa ambos campos antes de continuar.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Leer usuarios desde el archivo JSON
      List<dynamic> users = await _loadUsers();

      // Buscar el usuario con el correo y contraseña proporcionados
      bool userFound = false;
      for (var user in users) {
        if (user['email'] == email && user['password'] == password) {
          userFound = true;
          break;
        }
      }

      // Si el usuario no se encuentra, mostrar un mensaje de error
      if (userFound) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscotecaSearch(), // Reemplaza con la pantalla deseada
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Correo no registrado o Contraseña Incorrecta'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Imagen del logo
                Image.asset('assets/u.png'),
                const SizedBox(height: 20),
                // Título
                Text(
                  'Drinkmap',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Subtítulo
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Introduzca su email y contraseña',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de texto de email
                Container(
                  width: 300,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'email@domain.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de texto de contraseña
                Container(
                  width: 300,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true, // Ocultar el texto de la contraseña
                  ),
                ),
                const SizedBox(height: 20),
                // Botón Continuar
                Container(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () => _onContinue(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Center(
                      child: Text(
                        'Continuar',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Línea divisora
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'O',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Botón Google
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiscotecaSearch(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                  label: const Text('Continuar con Google'),
                ),
                const SizedBox(height: 10),
                // Botón Apple
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DiscotecaSearch(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(200, 50),
                  ),
                  icon: const Icon(Icons.apple, color: Colors.black),
                  label: const Text('Continuar con Apple'),
                ),
                const SizedBox(height: 20),
                // Crear nueva cuenta
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Crear nueva cuenta',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                // Políticas de privacidad
                Text(
                  'By clicking continue, you agree to our Terms of Service and Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
