import 'package:flutter/material.dart';
import 'package:drink_map/listado.dart';
import 'package:drink_map/file_manager.dart';

import 'dart:convert'; // Para convertir el JSON a Map
import 'dart:io'; // Para manipular archivos
import 'package:path_provider/path_provider.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final JsonManager fileManager = JsonManager();

  DateTime? selectedDate; // Fecha seleccionada
  bool isAdult = true; // Variable para controlar si el usuario es mayor de edad

  // Controladores para los campos de texto
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Estados de validación de los campos
  bool isNameValid = true;
  bool isLastNameValid = true;
  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isPasswordStrong = true; // Verifica si la contraseña es fuerte
  bool isConfirmPasswordValid = true;
  bool doPasswordsMatch = true; // Verifica si las contraseñas coinciden

  bool isPasswordVisible = false; // Para mostrar/ocultar la contraseña
  bool isConfirmPasswordVisible = false; // Para mostrar/ocultar la confirmación de contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            Text(
              "Iniciar sesión",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),

            // Campo de Nombre
            CustomInputField(
              label: 'Nombre',
              controller: nameController,
              isValid: isNameValid,
            ),
            SizedBox(height: 16),

            // Campo de Apellidos
            CustomInputField(
              label: 'Apellidos',
              controller: lastNameController,
              isValid: isLastNameValid,
            ),
            SizedBox(height: 16),

            // Campo de Edad con el calendario
            GestureDetector(
              onTap: () async {
                // Mostrar el calendario
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;

                    // Verificar si el usuario es mayor de edad
                    final currentDate = DateTime.now();
                    final age = currentDate.year - pickedDate.year;
                    if (pickedDate.month > currentDate.month ||
                        (pickedDate.month == currentDate.month && pickedDate.day > currentDate.day)) {
                      isAdult = age - 1 >= 18;
                    } else {
                      isAdult = age >= 18;
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isAdult ? Colors.grey[200] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isAdult ? Colors.transparent : Colors.red,
                    width: 2.0,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? 'Día/Mes/Año' // Placeholder inicial
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDate == null ? Colors.grey : Colors.black,
                      ),
                    ),
                    Icon(Icons.calendar_today, color: Colors.grey),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Campo de Correo
            CustomInputField(
              label: 'Correo',
              controller: emailController,
              isValid: isEmailValid,
            ),
            SizedBox(height: 16),

            // Campo de Contraseña
            CustomPasswordInputField(
              label: 'Contraseña',
              controller: passwordController,
              isValid: isPasswordValid && isPasswordStrong,
              isPasswordVisible: isPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            SizedBox(height: 16),

            // Campo de Confirmar Contraseña
            CustomPasswordInputField(
              label: 'Confirmar Contraseña',
              controller: confirmPasswordController,
              isValid: isConfirmPasswordValid && doPasswordsMatch,
              isPasswordVisible: isConfirmPasswordVisible,
              onVisibilityToggle: () {
                setState(() {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                });
              },
            ),
            SizedBox(height: 40), // Aumento del espacio para separar más el botón

            // Botón Aceptar
            ElevatedButton(
              onPressed: () async {
                // Validar campos
                setState(() {
                  isNameValid = nameController.text.isNotEmpty;
                  isLastNameValid = lastNameController.text.isNotEmpty;
                  isEmailValid = emailController.text.isNotEmpty;
                  isPasswordValid = passwordController.text.isNotEmpty;
                  isConfirmPasswordValid = confirmPasswordController.text.isNotEmpty;
                });

                bool isRegistered = await isEmailRegistered(emailController.text); // Aquí se puede usar await porque la función es async

                // Verificar si la contraseña es fuerte
                setState(() {
                  isPasswordStrong = validatePassword(passwordController.text);
                  // Validar si las contraseñas coinciden
                  doPasswordsMatch = passwordController.text == confirmPasswordController.text;
                });

                // Mostrar mensajes de error específicos
                if (!isNameValid || !isLastNameValid || !isEmailValid || !isPasswordValid || !isConfirmPasswordValid) {
                  showErrorSnackbar(context, 'Por favor, completa todos los campos.');
                } else if (!isAdult) {
                  showErrorSnackbar(context, 'La fecha seleccionada indica que no eres mayor de edad.');
                } else if (!isPasswordStrong) {
                  showErrorSnackbar(context,
                      'La contraseña debe contener al menos 8 caracteres, una mayúscula, un número y un carácter especial (!@#\$%^&*).');
                } else if (!doPasswordsMatch) {
                  showErrorSnackbar(context, 'Las contraseñas no coinciden.');
                } else if (isRegistered) {
                  showErrorSnackbar(context, 'El correo ya existe');
                } else {
                  // Todo está correcto
                  Map<String, dynamic> userData = {
                    'name': nameController.text,
                    'lastName': lastNameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'birthDate': selectedDate?.toIso8601String(),
                  };

                  // Guardar el usuario en el archivo JSON
                  await fileManager.saveUser(userData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Formulario enviado con éxito'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscotecaSearch(), // Navegar a la pantalla de búsqueda
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                'Aceptar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para verificar si el correo ya está registrado en el JSON
  Future<bool> isEmailRegistered(String email) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/users.json';
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> users = jsonDecode(jsonString);

        // Buscar si hay algún usuario con el correo proporcionado
        for (var user in users) {
          if (user['email'] == email) {
            return true; // El correo ya está registrado
          }
        }
        return false; // El correo no está registrado
      } else {
        return false; // Si el archivo no existe, no hay usuarios registrados
      }
    } catch (e) {
      print('Error al verificar el correo: $e');
      return false; // Si ocurre un error, tratamos como si no estuviera registrado
    }
  }

  // Función para validar la contraseña
  bool validatePassword(String password) {
    final hasUpperCase = RegExp(r'[A-Z]');
    final hasDigits = RegExp(r'\d');
    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final hasMinLength = password.length >= 8;

    return hasUpperCase.hasMatch(password) &&
        hasDigits.hasMatch(password) &&
        hasSpecialCharacters.hasMatch(password) &&
        hasMinLength;
  }

  // Función para mostrar el SnackBar con un mensaje de error
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Widget para crear campos de entrada reutilizables
class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isValid;

  CustomInputField({
    required this.label,
    required this.controller,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isValid ? Colors.grey[200] : Colors.red[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isValid ? Colors.transparent : Colors.red,
          width: 2.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// Widget personalizado para la contraseña con ícono de visibilidad
class CustomPasswordInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isValid;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;

  CustomPasswordInputField({
    required this.label,
    required this.controller,
    required this.isValid,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isValid ? Colors.grey[200] : Colors.red[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isValid ? Colors.transparent : Colors.red,
          width: 2.0,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onVisibilityToggle,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegistrationScreen(),
  ));
}