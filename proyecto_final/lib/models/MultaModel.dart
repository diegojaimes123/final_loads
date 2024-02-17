// ignore_for_file: file_names
// Importaciones necesarias para el código
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de categoría la cual esta relacionada al sitio reservado el cual se le relaciona la multa
class CategoriaMultaModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaMultaModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo de sitio reservado el cual se relaciona la multa
class SitioMultaModel {
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
  final CategoriaMultaModel categoria; // categoría relacionada al sitio

  const SitioMultaModel({
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

// Modelo de reserva relacionada a la multa
class ReservaMultaModel {
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
  final SitioMultaModel sitio; // sitio relacionado a la reserva

  const ReservaMultaModel(
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

// Modelo de multa
class MultaModel {
  final int id;
  final String fecha;
  final int valor;
  final int valorDevolucion;
  final ReservaMultaModel reserva;

  const MultaModel(
      {required this.id,
      required this.fecha,
      required this.valor,
      required this.valorDevolucion,
      required this.reserva});

  // Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get valorFormatted {
    return NumberFormat.currency(
      symbol: '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale: 'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits: 0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valor); // Aplicar el formato a la variable valor
  }

  // Funciones para formatear valores monetarios en formato de moneda colombiana (COP)
  String get valorDevolucionFormatted {
    return NumberFormat.currency(
      symbol: '', // Símbolo de la moneda (en este caso, vacío para tener solo el número)
      locale: 'es_CO', // Establecer el idioma y el país para el formato de moneda colombiana
      decimalDigits: 0, // Establecer la cantidad de dígitos decimales (0 para redondear al número entero más cercano)
    ).format(valorDevolucion); // Aplicar el formato a la variable valor devolución
  }
}

// Lista que contendrá instancias de MultaModel
List<MultaModel> multas = [];

// Función asíncrona para obtener la lista de multas desde una API
Future<List<MultaModel>> getMultas() async {
  String url = "";

  // Construir la URL de la API según la plataforma de ejecución
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Multas/";
  } else {
    url = "http://127.0.0.1:8000/api/Multas/";
  }

  // Realizar una solicitud HTTP GET a la URL especificada
  final response = await http.get(Uri.parse(url));

  // Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de multas antes de agregar nuevas instancias
    multas.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de todas las multas en decodedData
    for (var multaData in decodedData) {
      // Construir el modelo de multa para cada multa en la lista
      multas.add(MultaModel(
        id: multaData['id'] ?? 0,
        fecha: multaData['fecha'] ?? "",
        valor: multaData['valor'] ?? 0,
        valorDevolucion: multaData['valorDevolucion'] ?? 0,
        reserva: ReservaMultaModel(
          id: multaData['reserva']['id'] ?? 0,
          usuario: multaData['reserva']['usuario'] ?? 0,
          fecha: multaData['reserva']['fecha'] ?? "",
          fechaEntrada: multaData['reserva']['fechaEntrada'] ?? "",
          fechaSalida: multaData['reserva']['fechaSalida'] ?? "",
          numHuespedes: multaData['reserva']['numHuespedes'] ?? 0,
          numAdultos: multaData['reserva']['numAdultos'] ?? 0,
          numNinos: multaData['reserva']['numNinos'] ?? 0,
          numBebes: multaData['reserva']['numBebes'] ?? 0,
          numMascotas: multaData['reserva']['numMascotas'] ?? 0,
          precioFinal: multaData['reserva']['precioFinal'] ?? 0,
          estado: multaData['reserva']['estado'] ?? "",
          comision: multaData['reserva']['comision'] ?? 0,
          gananciaAnfitrion: multaData['reserva']['gananciaAnfitrion'] ?? 0,
          sitio: SitioMultaModel(
            id: multaData['reserva']['sitio']['id'] ?? 0,
            usuario: multaData['reserva']['sitio']['usuario'] ?? 0,
            titulo: multaData['reserva']['sitio']['titulo'] ?? "",
            numHuespedes: multaData['reserva']['sitio']['numHuespedes'] ?? 0,
            numCamas: multaData['reserva']['sitio']['numCamas'] ?? 0,
            numBanos: multaData['reserva']['sitio']['numBanos'] ?? 0,
            descripcion: multaData['reserva']['sitio']['descripcion'] ?? "",
            valorNoche: multaData['reserva']['sitio']['valorNoche'] ?? 0,
            lugar: multaData['reserva']['sitio']['lugar'] ?? "",
            desLugar: multaData['reserva']['sitio']['desLugar'] ?? "",
            latitud: multaData['reserva']['sitio']['latitud'] ?? "",
            longitud: multaData['reserva']['sitio']['longitud'] ?? "",
            continente: multaData['reserva']['sitio']['continente'] ?? "",
            valorLimpieza: multaData['reserva']['sitio']['valorLimpieza'] ?? 0,
            comision: multaData['reserva']['sitio']['comision'] ?? 0,
            politica: multaData['reserva']['sitio']['politica'] ?? false,
            categoria: CategoriaMultaModel(
              id: multaData['reserva']['sitio']['categoria']['id'] ?? 0,
              nombre:
                  multaData['reserva']['sitio']['categoria']['nombre'] ?? "",
              icono: multaData['reserva']['sitio']['categoria']['icono'] ?? "",
              imagen:
                  multaData['reserva']['sitio']['categoria']['imagen'] ?? "",
            ),
          ),
        ),
      ));
    }

    // Devolver la lista de multas construida
    return multas;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
