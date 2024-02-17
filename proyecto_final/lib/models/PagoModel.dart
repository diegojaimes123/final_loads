// ignore_for_file: file_names

// Importaciones necesarias para el código
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de categoría relacionada al sitio el cual se hara el pago de la reserva
class CategoriaPagoModel {
  final int id; // id de la categoría
  final String nombre; // nombre de la categoría
  final String icono; // icono de la categoría
  final String imagen; // imagen de la categoría

  const CategoriaPagoModel({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.imagen,
  });
}

// Modelo de sitio el cual se le hara el pago de la reserva
class SitioPagoModel {
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
  final CategoriaPagoModel categoria; // categoría relacionada al sitio

  const SitioPagoModel({
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

// Modelo de reserva relacionada al pago
class ReservaPagoModel {
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
  final SitioPagoModel sitio; // sitio relacionado a la reserva

  const ReservaPagoModel(
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

// Modelo de pago
class PagoModel {
  final int id; // id del pago
  final String fechaPago; // fecha del pago
  final String medioPago; // medio de pago
  final String estado; // estado del pago
  final ReservaPagoModel reserva; // reserva relacionada al pago

  const PagoModel(
      {required this.id,
      required this.fechaPago,
      required this.medioPago,
      required this.estado,
      required this.reserva});
}

// Lista para almacenar los objetos de modelo de pago
List<PagoModel> pagos = [];

// Función asincrónica para obtener la lista de pagos desde un servidor
Future<List<PagoModel>> getPagos() async {
  // URL base para la API de pagos
  String url = "";

// Seleccionar la URL según la plataforma de ejecución
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Pagos/";
  } else {
    url = "http://127.0.0.1:8000/api/Pagos/";
  }

  // Realizar una solicitud HTTP GET a la URL
  final response = await http.get(Uri.parse(url));

// Verificar si la solicitud fue exitosa (código de estado 200)
  if (response.statusCode == 200) {
    // Limpiar la lista de pagos antes de agregar nuevos elementos
    pagos.clear();

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de los datos decodificados y construir objetos de modelo de pago
    for (var pagoData in decodedData) {
      // Construir el modelo de pago
      pagos.add(PagoModel(
        id: pagoData['id'] ?? 0,
        fechaPago: pagoData['fechaPago'] ?? "",
        medioPago: pagoData['medioPago'] ?? "",
        estado: pagoData['estado'] ?? "",
        reserva: ReservaPagoModel(
          id: pagoData['reserva']['id'] ?? 0,
          usuario: pagoData['reserva']['usuario'] ?? 0,
          fecha: pagoData['reserva']['fecha'] ?? "",
          fechaEntrada: pagoData['reserva']['fechaEntrada'] ?? "",
          fechaSalida: pagoData['reserva']['fechaSalida'] ?? "",
          numHuespedes: pagoData['reserva']['numHuespedes'] ?? 0,
          numAdultos: pagoData['reserva']['numAdultos'] ?? 0,
          numNinos: pagoData['reserva']['numNinos'] ?? 0,
          numBebes: pagoData['reserva']['numBebes'] ?? 0,
          numMascotas: pagoData['reserva']['numMascotas'] ?? 0,
          precioFinal: pagoData['reserva']['precioFinal'] ?? 0,
          estado: pagoData['reserva']['estado'] ?? "",
          comision: pagoData['reserva']['comision'] ?? 0,
          gananciaAnfitrion: pagoData['reserva']['gananciaAnfitrion'] ?? 0,
          sitio: SitioPagoModel(
            id: pagoData['reserva']['sitio']['id'] ?? 0,
            usuario: pagoData['reserva']['sitio']['usuario'] ?? 0,
            titulo: pagoData['reserva']['sitio']['titulo'] ?? "",
            numHuespedes: pagoData['reserva']['sitio']['numHuespedes'] ?? 0,
            numCamas: pagoData['reserva']['sitio']['numCamas'] ?? 0,
            numBanos: pagoData['reserva']['sitio']['numBanos'] ?? 0,
            descripcion: pagoData['reserva']['sitio']['descripcion'] ?? "",
            valorNoche: pagoData['reserva']['sitio']['valorNoche'] ?? 0,
            lugar: pagoData['reserva']['sitio']['lugar'] ?? "",
            desLugar: pagoData['reserva']['sitio']['desLugar'] ?? "",
            latitud: pagoData['reserva']['sitio']['latitud'] ?? "",
            longitud: pagoData['reserva']['sitio']['longitud'] ?? "",
            continente: pagoData['reserva']['sitio']['continente'] ?? "",
            valorLimpieza: pagoData['reserva']['sitio']['valorLimpieza'] ?? 0,
            comision: pagoData['reserva']['sitio']['comision'] ?? 0,
            politica: pagoData['reserva']['sitio']['politica'] ?? false,
            categoria: CategoriaPagoModel(
              id: pagoData['reserva']['sitio']['categoria']['id'] ?? 0,
              nombre: pagoData['reserva']['sitio']['categoria']['nombre'] ?? "",
              icono: pagoData['reserva']['sitio']['categoria']['icono'] ?? "",
              imagen: pagoData['reserva']['sitio']['categoria']['imagen'] ?? "",
            ),
          ),
        ),
      ));
    }

    // Devolver la lista de pagos construida
    return pagos;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
