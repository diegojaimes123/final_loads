// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';
import 'package:intl/intl.dart';

import 'ip/local.dart';

// Modelo de categoría relacionada al sitio
class CategoriaSitioModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaSitioModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo de datos para representar un sitio
class SitioModel {
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
  final CategoriaSitioModel categoria; // categoría relacionada al sitio

  const SitioModel({
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

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get valorNocheFormatted {
    return NumberFormat.currency(
      symbol:
          '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale:
          'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits:
          0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valorNoche); // Aplicar el formato a la variable valorNoche
  }

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get comisionFormatted {
    return NumberFormat.currency(
      symbol:
          '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale:
          'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits:
          0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(comision); // Aplicar el formato a la variable comisión
  }

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get valorLimpiezaFormatted {
    return NumberFormat.currency(
      symbol:
          '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale:
          'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits:
          0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valorLimpieza); // Aplicar el formato a la variable valorLimpieza
  }
}

// Lista que contendrá los objetos SitioModel
List<SitioModel> sitio = [];

// Función asincrónica para obtener la lista de sitios desde la API
Future<List<SitioModel>> getSitios() async {
  String url = "";

  // Verificar la plataforma para ajustar la URL base según el entorno
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Sitios/";
  } else {
    url = "http://127.0.0.1:8000/api/Sitios/";
  }

  // Realizar la solicitud HTTP para obtener la lista de sitios
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de respuesta 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de sitios antes de agregar nuevos elementos
    sitio.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todos los sitios en decodedData
    for (var sitioData in decodedData) {
      // Construir el modelo de sitio para cada sitio en la lista
      sitio.add(SitioModel(
        id: sitioData['id'] ?? 0,
        usuario: sitioData['usuario'] ?? 0,
        titulo: sitioData['titulo'] ?? "",
        numHuespedes: sitioData['numHuespedes'] ?? 0,
        numCamas: sitioData['numCamas'] ?? 0,
        numBanos: sitioData['numBanos'] ?? 0,
        descripcion: sitioData['descripcion'] ?? "",
        valorNoche: sitioData['valorNoche'] ?? 0,
        lugar: sitioData['lugar'] ?? "",
        desLugar: sitioData['desLugar'] ?? "",
        latitud: sitioData['latitud'] ?? "",
        longitud: sitioData['longitud'] ?? "",
        continente: sitioData['continente'] ?? "",
        valorLimpieza: sitioData['valorLimpieza'] ?? 0,
        comision: sitioData['comision'] ?? 0,
        politica: sitioData['politica'] ?? false,
        categoria: CategoriaSitioModel(
          id: sitioData['categoria']['id'] ?? 0,
          nombre: sitioData['categoria']['nombre'] ?? "",
          icono: sitioData['categoria']['icono'] ?? "",
          imagen: sitioData['categoria']['imagen'] ?? "",
        ),
      ));
    }

    // Devolver la lista de sitios construida
    return sitio;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
