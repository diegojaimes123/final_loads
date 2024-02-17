// ignore_for_file: file_names
// Importaciones necesarias
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyecto_final/models/ip/local.dart';
import 'package:universal_platform/universal_platform.dart';

// Modelo para la categoría relacionada al sitio el cual se relaciona el comentario
class CategoriaComentarioModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaComentarioModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo para el sitio relacionado a un comentario
class SitioComentarioModel {
  final int id; // id del sitio
  final int usuario; //id del usuario
  final String titulo; // titulo del sitio
  final int numHuespedes; // número de huespedes
  final int numCamas; // número de camas
  final int numBanos; // número de baños
  final String descripcion; // descripción del sitio
  final int valorNoche; // valor de la noche
  final String lugar; // lugar 
  final String desLugar; // descripción del lugar
  final String latitud; // latitud
  final String longitud; // longitud
  final String continente; // continente
  final int valorLimpieza; // valor de la limpieza
  final int comision; // comisión StayAway
  final bool politica; // politicas de StayAway
  final CategoriaComentarioModel categoria; // categoría relacionada al sitio

  const SitioComentarioModel({
    required this.id,
    required this.usuario,
    required this.titulo,
    required this.numHuespedes,
    required this.numCamas,
    required this.numBanos,
    required this.descripcion,
    required this.valorNoche,
    required this.lugar,
    required this.desLugar,
    required this.latitud,
    required this.longitud,
    required this.continente,
    required this.valorLimpieza,
    required this.comision,
    required this.politica,
    required this.categoria,
  });
}

// Modelo para los comentarios
class ComentarioModel {
  final int id; // id del comentario
  final int usuario; // id del usuario
  final String fecha; // fecha del comentario
  final double calLimpieza; // calificación limpieza
  final String desLimpieza; // descripción en caso que la calificación de la limpieza sea menor a 3
  final double calComunicacion; // calificación comunicación
  final String desComunicacion; // descripción en caso que la calificación  de la comunicación sea menor a 3
  final double calLlegada; // calificación llegada
  final String desLlegada; // descripción en caso que la calificación  de la llegada sea menor a 3
  final double calFiabilidad; // calificación fiabilidad
  final String desFiabilidad; // descripción en caso que la calificación  de la fiabilidad sea menor a 3
  final double calUbicacion; // calificación ubicación
  final String desUbicacion; // descripción en caso que la calificación  de la ubicación sea menor a 3
  final double calPrecio; // calificación precio
  final String desPrecio; // descripción en caso que la calificación  del precio sea menor a 3
  final String descripcion; // descripción del comentario
  final SitioComentarioModel sitio; // sitio el cual esta relacionado el comentario

  const ComentarioModel(
      {required this.id,
      required this.usuario,
      required this.fecha,
      required this.calLimpieza,
      required this.desLimpieza,
      required this.calComunicacion,
      required this.desComunicacion,
      required this.calLlegada,
      required this.desLlegada,
      required this.calFiabilidad,
      required this.desFiabilidad,
      required this.calUbicacion,
      required this.desUbicacion,
      required this.calPrecio,
      required this.desPrecio,
      required this.descripcion,
      required this.sitio});
}

// Lista para almacenar los modelos de comentarios
List<ComentarioModel> comentario = [];

// Función para obtener la lista de comentarios desde la API
Future<List<ComentarioModel>> getComentarios() async {
  String url = "";

  // Determinar la URL base según la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Comentarios/";
  } else {
    url = "http://127.0.0.1:8000/api/Comentarios/";
  }

  // Realizar la solicitud HTTP
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de comentarios antes de agregar nuevos
    comentario.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los comentarios en decodedData
    for (var comentarioData in decodedData) {
      // Construir el modelo de comentario para cada comentario en la lista
      comentario.add(ComentarioModel(
        id: comentarioData['id'] ?? 0,
        usuario: comentarioData['usuario'] ?? 0,
        fecha: comentarioData['fecha'] ?? "",
        calLimpieza: comentarioData['calLimpieza'] ?? 0.0,
        desLimpieza: comentarioData['desLimpieza'] ?? "",
        calComunicacion: comentarioData['calComunicacion'] ?? 0.0,
        desComunicacion: comentarioData['desComunicacion'] ?? "",
        calLlegada: comentarioData['calLlegada'] ?? 0.0,
        desLlegada: comentarioData['desLlegada'] ?? "",
        calFiabilidad: comentarioData['calFiabilidad'] ?? 0.0,
        desFiabilidad: comentarioData['desFiabilidad'] ?? "",
        calUbicacion: comentarioData['calUbicacion'] ?? 0.0,
        desUbicacion: comentarioData['desUbicacion'] ?? "",
        calPrecio: comentarioData['calPrecio'] ?? 0.0,
        desPrecio: comentarioData['desPrecio'] ?? "",
        descripcion: comentarioData['descripcion'] ?? "",
        sitio: SitioComentarioModel(
          id: comentarioData['sitio']['id'] ?? 0,
          usuario: comentarioData['sitio']['usuario'] ?? 0,
          titulo: comentarioData['sitio']['titulo'] ?? "",
          numHuespedes: comentarioData['sitio']['numHuespedes'] ?? 0,
          numCamas: comentarioData['sitio']['numCamas'] ?? 0,
          numBanos: comentarioData['sitio']['numBanos'] ?? 0,
          descripcion: comentarioData['sitio']['descripcion'] ?? "",
          valorNoche: comentarioData['sitio']['valorNoche'] ?? 0,
          lugar: comentarioData['sitio']['lugar'] ?? "",
          desLugar: comentarioData['sitio']['desLugar'] ?? "",
          latitud: comentarioData['sitio']['latitud'] ?? "",
          longitud: comentarioData['sitio']['longitud'] ?? "",
          continente: comentarioData['sitio']['continente'] ?? "",
          valorLimpieza: comentarioData['sitio']['valorLimpieza'] ?? 0,
          comision: comentarioData['sitio']['comision'] ?? 0,
          politica: comentarioData['sitio']['politica'] ?? false,
          categoria: CategoriaComentarioModel(
            id: comentarioData['sitio']['categoria']['id'] ?? 0,
            nombre: comentarioData['sitio']['categoria']['nombre'] ?? "",
            icono: comentarioData['sitio']['categoria']['icono'] ?? "",
            imagen: comentarioData['sitio']['categoria']['imagen'] ?? "",
          ),
        ),
      ));
    }

    // Devolver la lista de comentarios
    return comentario;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
