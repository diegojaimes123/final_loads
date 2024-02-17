// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo para la categoría relacionada al sitio el cual se relaciona las devoluciones
class CategoriaDevolucionModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaDevolucionModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo para el sitio relacionado a la reserva a la cual se hara la devolución
class SitioDevolucionModel {
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
  final CategoriaDevolucionModel categoria; // categoría relacionada al sitio

  const SitioDevolucionModel({
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

// Modelo de reserva relacionada a las devoluciones
class ReservaDevolucionModel {
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
  final SitioDevolucionModel sitio; // sitio relacionado a la reserva

  const ReservaDevolucionModel(
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
}

// Modelo para las devoluciones
class DevolucionModel {
  final int id; // id de la devolución
  final String fechaRadicado; // fecha de radicado
  final String fechaPago; // fecha de pago de la devolución
  final int valor; // valor de la devolución
  final String estado; // estado de la devolución 
  final ReservaDevolucionModel reserva; // reserva relacionada a la devolución

  const DevolucionModel(
      {required this.id,
      required this.fechaRadicado,
      required this.fechaPago,
      required this.valor,
      required this.estado,
      required this.reserva});

  // Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get valorFormatted {
    return NumberFormat.currency(
      symbol: '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale: 'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits: 0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valor); // Aplicar el formato a la variable valor
  }
}

// Lista que contendrá los modelos de devolución
List<DevolucionModel> devoluciones = [];

// Función asíncrona para obtener las devoluciones desde el servidor
Future<List<DevolucionModel>> getDevoluciones() async {
  String url = "";

  // Configurar la URL según la plataforma (Android o no Android)
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Devolucion/";
  } else {
    url = "http://127.0.0.1:8000/api/Devolucion/";
  }

  // Realizar una solicitud HTTP GET para obtener los datos
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    devoluciones.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todas las devoluciones en decodedData
    for (var devolucionData in decodedData) {
      // Construir el modelo de devolución para cada devolución en la lista
      devoluciones.add(DevolucionModel(
        id: devolucionData['id'] ?? 0,
        fechaRadicado: devolucionData['fechaRadicado'] ?? "",
        fechaPago: devolucionData['fechaPago'] ?? "",
        valor: devolucionData['valor'] ?? 0,
        estado: devolucionData['estado'] ?? 0,
        reserva: ReservaDevolucionModel(
          id: devolucionData['reserva']['id'] ?? 0,
          usuario: devolucionData['reserva']['usuario'] ?? 0,
          fecha: devolucionData['reserva']['fecha'] ?? "",
          fechaEntrada: devolucionData['reserva']['fechaEntrada'] ?? "",
          fechaSalida: devolucionData['reserva']['fechaSalida'] ?? "",
          numHuespedes: devolucionData['reserva']['numHuespedes'] ?? 0,
          numAdultos: devolucionData['reserva']['numAdultos'] ?? 0,
          numNinos: devolucionData['reserva']['numNinos'] ?? 0,
          numBebes: devolucionData['reserva']['numBebes'] ?? 0,
          numMascotas: devolucionData['reserva']['numMascotas'] ?? 0,
          precioFinal: devolucionData['reserva']['precioFinal'] ?? 0,
          estado: devolucionData['reserva']['estado'] ?? "",
          comision: devolucionData['reserva']['comision'] ?? 0,
          gananciaAnfitrion:
              devolucionData['reserva']['gananciaAnfitrion'] ?? 0,
          sitio: SitioDevolucionModel(
            id: devolucionData['reserva']['sitio']['id'] ?? 0,
            usuario: devolucionData['reserva']['sitio']['usuario'] ?? 0,
            titulo: devolucionData['reserva']['sitio']['titulo'] ?? "",
            numHuespedes:
                devolucionData['reserva']['sitio']['numHuespedes'] ?? 0,
            numCamas: devolucionData['reserva']['sitio']['numCamas'] ?? 0,
            numBanos: devolucionData['reserva']['sitio']['numBanos'] ?? 0,
            descripcion:
                devolucionData['reserva']['sitio']['descripcion'] ?? "",
            valorNoche: devolucionData['reserva']['sitio']['valorNoche'] ?? 0,
            lugar: devolucionData['reserva']['sitio']['lugar'] ?? "",
            desLugar: devolucionData['reserva']['sitio']['desLugar'] ?? "",
            latitud: devolucionData['reserva']['sitio']['latitud'] ?? "",
            longitud: devolucionData['reserva']['sitio']['longitud'] ?? "",
            continente: devolucionData['reserva']['sitio']['continente'] ?? "",
            valorLimpieza:
                devolucionData['reserva']['sitio']['valorLimpieza'] ?? 0,
            comision: devolucionData['reserva']['sitio']['comision'] ?? 0,
            politica: devolucionData['reserva']['sitio']['politica'] ?? false,
            categoria: CategoriaDevolucionModel(
              id: devolucionData['reserva']['sitio']['categoria']['id'] ?? 0,
              nombre: devolucionData['reserva']['sitio']['categoria']
                      ['nombre'] ??
                  "",
              icono: devolucionData['reserva']['sitio']['categoria']['icono'] ??
                  "",
              imagen: devolucionData['reserva']['sitio']['categoria']
                      ['imagen'] ??
                  "",
            ),
          ),
        ),
      ));
    }

    // Devolver la lista de devoluciones construida
    return devoluciones;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
