// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Clase que representa un modelo de favorito
class FavoritoModel {
  final int id; // id favorito
  final int usuario; // id usuario el cual guardo sitio como favorito
  final int sitio; // id sitio favorito

  // Constructor de la clase FavoritoModel
  FavoritoModel({
    required this.id,
    required this.usuario,
    required this.sitio,
  });
}

// Lista que contendrá instancias de FavoritoModel
List<FavoritoModel> favorito = [];

// Función asíncrona para obtener la lista de favoritos desde una API
Future<List<FavoritoModel>> getFavorito() async {
  String url = "";

  // Construir la URL de la API según la plataforma de ejecución
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Favoritos/";
  } else {
    url = "http://127.0.0.1:8000/api/Favoritos/";
  }

  // Realizar una solicitud HTTP GET a la URL especificada
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de favoritos antes de agregar nuevas instancias
    favorito.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los favoritos en decodedData
    for (var favoritoData in decodedData) {
      // Construir el modelo de favorito para cada favorito en la lista
      favorito.add(FavoritoModel(
        id: favoritoData['id'] ?? 0,
        usuario: favoritoData['usuario'] ?? 0,
        sitio: favoritoData['sitio'] ?? 0,
      ));
    }

    // Devolver la lista de favoritos construida
    return favorito;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
