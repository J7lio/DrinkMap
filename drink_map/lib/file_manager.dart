import 'dart:io';
import 'dart:convert'; // Para convertir Map a JSON y viceversa
import 'package:path_provider/path_provider.dart';

class JsonManager {
  // Obtener el directorio donde guardar el archivo
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/users.json'; // Archivo para guardar usuarios
  }

  // Guardar datos de usuario en un archivo JSON
  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      // Leer usuarios existentes, si no hay, crear una lista vacía
      List<dynamic> users = [];
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        users = jsonDecode(jsonString);
      }

      // Agregar nuevo usuario
      users.add(userData);

      // Guardar la lista actualizada
      final jsonString = jsonEncode(users);
      await file.writeAsString(jsonString);

      print('Usuario guardado correctamente en $filePath');
    } catch (e) {
      print('Error al guardar usuario: $e');
    }
  }

  // Leer los usuarios desde el archivo JSON
  Future<List<dynamic>> loadUsers() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return jsonDecode(jsonString); // Lista de usuarios
      } else {
        print('Archivo de usuarios no encontrado.');
        return [];
      }
    } catch (e) {
      print('Error al cargar usuarios: $e');
      return [];
    }
  }
}
