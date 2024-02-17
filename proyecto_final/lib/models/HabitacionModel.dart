// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Clase que representa un modelo de habitación
class HabitacionModel {
  final int id; // id habitación
  final String titulo; // titulo habitación
  final String descripcion; // descripción de la habitación
  final int sitio; // id sitio relacionado a la habitación

  // Constructor de la clase HabitacionModel
  HabitacionModel(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.sitio});
}

// Lista que contendrá instancias de HabitacionModel
List<HabitacionModel> habitacion = [];

// Función asíncrona para obtener la lista de habitaciones desde una API
Future<List<HabitacionModel>> getHabitacion() async {
  String url = "";

  // Construir la URL de la API según la plataforma de ejecución
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Habitacion/";
  } else {
    url = "http://127.0.0.1:8000/api/Habitacion/";
  }

  // Realizar una solicitud HTTP GET a la URL especificada
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de habitaciones antes de agregar nuevas instancias
    habitacion.clear();

    // Decodificar la respuesta JSON a UTF-8
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todas las habitaciones en decodedData
    for (var habitacionData in decodedData) {
      // Construir el modelo de habitación para cada habitación en la lista
      habitacion.add(HabitacionModel(
        id: habitacionData['id'] ?? 0,
        titulo: habitacionData['titulo'] ?? "",
        descripcion: habitacionData['descripcion'] ?? "",
        sitio: habitacionData['sitio'] ?? "",
      ));
    }

    // Devolver la lista de habitaciones construida
    return habitacion;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
