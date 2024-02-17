// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de datos para representar un Sitio Visitado
class SitioVisitadoModel {
  final int id; // id sitio visitado
  final String fechaVista; // fecha de vista del sitio
  final int sitio; // id del sitio visitado
  final int usuario; // id del usuario que vio el sitio

  SitioVisitadoModel({
    required this.id,
    required this.fechaVista,
    required this.sitio,
    required this.usuario,
  });
}

// Lista que almacenará los sitios visitados
List<SitioVisitadoModel> sitioVisitado = [];

// Función asincrónica para obtener datos de sitios visitados desde la API
Future<List<SitioVisitadoModel>> getSitioVisitado() async {
  String url = "";

  // Configuración de la URL dependiendo de la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/SitioVisitado/"; // Emulador de Android
  } else {
    url =
        "http://127.0.0.1:8000/api/SitioVisitado/"; // Dispositivo o emulador no Android
  }

  // Realizar una solicitud HTTP GET
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    sitioVisitado.clear(); // Limpiar la lista de sitios visitados

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los usuarios en decodedData
    for (var sitioVisitadoData in decodedData) {
      sitioVisitado.add(SitioVisitadoModel(
        id: sitioVisitadoData['id'] ?? 0,
        fechaVista: sitioVisitadoData['fechaVista'] ?? "",
        sitio: sitioVisitadoData['sitio'] ?? 0,
        usuario: sitioVisitadoData['usuario'] ?? 0,
      ));
    }

    // Devolver la lista de sitios visitados
    return sitioVisitado;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
