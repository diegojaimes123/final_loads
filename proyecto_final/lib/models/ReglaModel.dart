// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de regla
class ReglaModel {
  final int id; //id regla
  final String descripcion; // descripción de la regla
  final int sitio; // id del sitio relacionado a regla

  ReglaModel(
      {required this.id, required this.descripcion, required this.sitio});
}

// Lista para almacenar los objetos del modelo regla
List<ReglaModel> regla = [];

Future<List<ReglaModel>> getRegla() async {
  String url = "";

  // Determinar la URL según la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Reglas/";
  } else {
    url = "http://127.0.0.1:8000/api/Reglas/";
  }

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Limpiar la lista antes de agregar nuevas reglas
    regla.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todas las reglas en decodedData
    for (var reglaData in decodedData) {
      // Construir el modelo de regla para cada regla en la lista
      regla.add(ReglaModel(
        id: reglaData['id'] ?? 0,
        descripcion: reglaData['descripcion'] ?? "",
        sitio: reglaData['sitio'] ?? "",
      ));
    }

    // Devolver la lista de reglas construida
    return regla;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
