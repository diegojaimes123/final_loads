// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto_final/models/ip/local.dart';
import 'package:universal_platform/universal_platform.dart';

// Definición del modelo de categoría
class CategoriaModel {
  final int id; // Id de la categoría
  final String nombre; // Nombre de la categoría
  final String icono; // Icono de la categoría
  final String imagen; // Imagen de la categoría

  CategoriaModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Lista para almacenar instancias del modelo de categoría
List<CategoriaModel> categoria = [];

// Función asincrónica para obtener la lista de categorías desde la API
Future<List<CategoriaModel>> getCategoria() async {
  String url = "";

  // Construir la URL de la API basándose en la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Categorias/";
  } else {
    url = "http://127.0.0.1:8000/api/Categorias/";
  }

  // Realizar la solicitud HTTP GET
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de llenarla con datos actualizados
    categoria.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los datos de categoría en decodedData
    for (var categoriaData in decodedData) {
      // Construir el modelo de categoría para cada categoría en la lista
      categoria.add(CategoriaModel(
        id: categoriaData['id'] ?? 0,
        nombre: categoriaData['nombre'] ?? "",
        icono: categoriaData['icono'] ?? "",
        imagen: categoriaData['imagen'] ?? "",
      ));
    }

    // Devolver la lista de categorías
    return categoria;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
