// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Clase que representa un modelo de imagen
class ImagenModel {
  final int id; // id de la imagen
  final String direccion; // dirección donde esta alojada la imagen
  final int sitio; // id del sitio el cual esta relacionado la imagen

  ImagenModel({required this.id, required this.direccion, required this.sitio});
}

// Lista que contendrá instancias de ImagenModel
List<ImagenModel> imagen = [];

// Función asíncrona para obtener la lista de imágenes desde una API
Future<List<ImagenModel>> getImagen() async {
  String url = "";

  // Construir la URL de la API según la plataforma de ejecución
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Imagen/";
  } else {
    url = "http://127.0.0.1:8000/api/Imagen/";
  }

  // Realizar una solicitud HTTP GET a la URL especificada
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de imágenes antes de agregar nuevas instancias
    imagen.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los usuarios en decodedData
    for (var imagenData in decodedData) {
      // Construir el modelo de usuario para cada usuario en la lista
      imagen.add(ImagenModel(
        id: imagenData['id'] ?? 0,
        direccion: imagenData['direccion'] ?? "",
        sitio: imagenData['sitio'] ?? "",
      ));
    }

    // Devolver la lista de imágenes construida
    return imagen;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
