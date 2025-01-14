import 'package:flutter/material.dart';

import 'dart:convert'; // Para convertir entre Map y JSON
import 'dart:io'; // Para manejar archivos
import 'package:path_provider/path_provider.dart'; // Para obtener rutas

class FileManager {
  // Obtener el directorio donde guardar el archivo
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/data.json'; // Archivo en el directorio
  }

  // Leer datos de un archivo JSON
  Future<Map<String, dynamic>?> loadData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        return jsonDecode(jsonString); // Convertir JSON a Map
      } else {
        print('Archivo no encontrado');
        return null;
      }
    } catch (e) {
      print('Error al leer datos: $e');
      return null;
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JSON Reader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Leer JSON y Mostrar en Terminal'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fileManager = FileManager();

  // Función para leer y mostrar datos
  void _readAndDisplayData() async {
    final loadedData = await fileManager.loadData();
    if (loadedData != null) {
      print('Datos cargados: $loadedData');
    } else {
      print('No se pudo cargar ningún dato.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Presiona el botón para leer y mostrar los datos del archivo JSON:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readAndDisplayData,
        tooltip: 'Leer Datos',
        child: const Icon(Icons.download),
      ),
    );
  }
}
