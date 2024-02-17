// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de categoría relacionada al sitio el cual se hara la reserva
class CategoriaReservaModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaReservaModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo de sitio el cual se le hara la reserva
class SitioReservaModel {
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
  final CategoriaReservaModel categoria; // categoría relacionada al sitio

  const SitioReservaModel({
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

// Modelo que representa una reserva
class ReservaModel {
  final int id; // id reserva
  final int usuario; // id usuario
  final String fecha; // fecha de la reserva
  final String fechaEntrada; // fecha de entrada
  final String fechaSalida; // fecha de salida
  final int numHuespedes; // número de huespedes
  final int numAdultos; // número de adultos
  final int numNinos; // número de niños
  final int numBebes; // número de bebes
  final int numMascotas; // número de mascotas
  final int precioFinal; // precio final
  final String estado; // estado de la reserva
  final int comision; // comisión StayAway
  final int gananciaAnfitrion; // ganancia del anfitrión
  final SitioReservaModel sitio; // sitio relacionado a la reserva

  const ReservaModel(
      {required this.id,
      required this.usuario,
      required this.fecha,
      required this.fechaEntrada,
      required this.fechaSalida,
      required this.numHuespedes,
      required this.numAdultos,
      required this.numNinos,
      required this.numBebes,
      required this.numMascotas,
      required this.precioFinal,
      required this.estado,
      required this.comision,
      required this.gananciaAnfitrion,
      required this.sitio});

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get precioFinalFormatted {
    return NumberFormat.currency(
      symbol:
          '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale:
          'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits:
          0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(precioFinal); // Aplicar el formato a la variable precioFinal
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
    ).format(comision); // Aplicar el formato a la variable comision
  }

// Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get gananciaAnfitrionFormatted {
    return NumberFormat.currency(
      symbol:
          '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale:
          'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits:
          0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(
        gananciaAnfitrion); // Aplicar el formato a la variable gananciaAnfitrion
  }
}

// Lista para almacenar los objetos de modelo de reserva
List<ReservaModel> reserva = [];

// Función para obtener la lista de reservas desde la API
Future<List<ReservaModel>> getReservas() async {
  String url = "";

  // Construir la URL de la API según la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Reservas/";
  } else {
    url = "http://127.0.0.1:8000/api/Reservas/";
  }

  // Realizar la solicitud HTTP GET
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de reservas antes de llenarla con los nuevos datos
    reserva.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todas las reservas en decodedData
    for (var reservaData in decodedData) {
      // Construir el modelo de reserva para cada reserva en la lista
      reserva.add(ReservaModel(
        id: reservaData['id'] ?? 0,
        usuario: reservaData['usuario'] ?? 0,
        fecha: reservaData['fecha'] ?? "",
        fechaEntrada: reservaData['fechaEntrada'] ?? "",
        fechaSalida: reservaData['fechaSalida'] ?? "",
        numHuespedes: reservaData['numHuespedes'] ?? 0,
        numAdultos: reservaData['numAdultos'] ?? 0,
        numNinos: reservaData['numNinos'] ?? 0,
        numBebes: reservaData['numBebes'] ?? 0,
        numMascotas: reservaData['numMascotas'] ?? 0,
        precioFinal: reservaData['precioFinal'] ?? 0,
        estado: reservaData['estado'] ?? "",
        comision: reservaData['comision'] ?? 0,
        gananciaAnfitrion: reservaData['gananciaAnfitrion'] ?? 0,
        sitio: SitioReservaModel(
          id: reservaData['sitio']['id'] ?? 0,
          usuario: reservaData['sitio']['usuario'] ?? 0,
          titulo: reservaData['sitio']['titulo'] ?? "",
          numHuespedes: reservaData['sitio']['numHuespedes'] ?? 0,
          numCamas: reservaData['sitio']['numCamas'] ?? 0,
          numBanos: reservaData['sitio']['numBanos'] ?? 0,
          descripcion: reservaData['sitio']['descripcion'] ?? "",
          valorNoche: reservaData['sitio']['valorNoche'] ?? 0,
          lugar: reservaData['sitio']['lugar'] ?? "",
          desLugar: reservaData['sitio']['desLugar'] ?? "",
          latitud: reservaData['sitio']['latitud'] ?? "",
          longitud: reservaData['sitio']['longitud'] ?? "",
          continente: reservaData['sitio']['continente'] ?? "",
          valorLimpieza: reservaData['sitio']['valorLimpieza'] ?? 0,
          comision: reservaData['sitio']['comision'] ?? 0,
          politica: reservaData['sitio']['politica'] ?? false,
          categoria: CategoriaReservaModel(
            id: reservaData['sitio']['categoria']['id'] ?? 0,
            nombre: reservaData['sitio']['categoria']['nombre'] ?? "",
            icono: reservaData['sitio']['categoria']['icono'] ?? "",
            imagen: reservaData['sitio']['categoria']['imagen'] ?? "",
          ),
        ),
      ));
    }

    // Devolver la lista de reservas
    return reserva;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
