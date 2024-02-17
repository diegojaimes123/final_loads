// ignore_for_file: file_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'ip/local.dart';

// Modelo de datos para representar un usuario
class UsuariosModel {
  final int id; // id del usuario
  final String nombreCompleto; // nombre completo
  final String tipoDocumento; // tipo de documento
  final String numeroDocumento; // número de documento
  final String correoElectronico; // correo electrónico
  final String telefono; // teléfono fijo
  final String telefonoCelular; // teléfono celular
  final String idioma; // idiomas que habla el usuario
  final String foto; // foto del usuario
  final bool rolAdmin; // rol del usuario
  final String descripcion; // descripción del usuario
  final String
      banco; // nombre del banco al cual se le pagara el alquiler del sitio o se le devolvera el dinero en caso que cancele una reserva
  final String
      numeroCuenta; // número de cuenta al cual se le pagara el alquiler del sitio o se le devolvera el dinero en caso que cancele una reserva
  final String
      daviplata; // número de daviplata al cual se le pagara el alquiler del sitio o se le devolvera el dinero en caso que cancele una reserva
  final String fechaRegistro; // fecha de registro del usuario

  const UsuariosModel({
    required this.id,
    required this.nombreCompleto,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.correoElectronico,
    required this.telefono,
    required this.telefonoCelular,
    required this.idioma,
    required this.foto,
    required this.rolAdmin,
    required this.descripcion,
    required this.banco,
    required this.numeroCuenta,
    required this.daviplata,
    required this.fechaRegistro,
  });
}

// Lista que almacenará los usuarios
List<UsuariosModel> usuario = [];

// Función asincrónica para obtener datos de usuarios desde la API
Future<List<UsuariosModel>> getUsuario() async {
  String url = "";

  // Configuración de la URL dependiendo de la plataforma
  if (UniversalPlatform.isAndroid) {
    url = "http://$ip_ideapat:8000/api/Usuarios/"; // Emulador de Android
  } else {
    url =
        "http://127.0.0.1:8000/api/Usuarios/"; // Dispositivo o emulador no Android
  }

  // Realizar una solicitud HTTP GET
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    usuario.clear(); // Limpiar la lista de usuarios

    // Decodificar la respuesta JSON
    String responseBodyUtf8 = utf8.decode(response.bodyBytes);
    List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

    // Iterar a través de los datos decodificados y construir instancias de UsuariosModel
    for (var userData in decodedData) {
      // Construir el modelo de usuario para cada usuario en la lista
      usuario.add(UsuariosModel(
        id: userData['id'] ?? 0,
        nombreCompleto: userData['nombreCompleto'] ?? "",
        tipoDocumento: userData['tipoDocumento'] ?? "",
        numeroDocumento: userData['numeroDocumento'] ?? "",
        correoElectronico: userData['correoElectronico'] ?? "",
        telefono: userData['telefono'] ?? "",
        telefonoCelular: userData['telefonoCelular'] ?? "",
        idioma: userData['idioma'] ?? "",
        foto: userData['foto'] ?? "",
        rolAdmin: userData['rolAdmin'] ?? false,
        descripcion: userData['descripcion'] ?? "",
        banco: userData['banco'] ?? "",
        numeroCuenta: userData['numeroCuenta'] ?? "",
        daviplata: userData['daviplata'] ?? "",
        fechaRegistro: userData['fechaRegistro'] ?? "",
      ));
    }

    // Devolver la lista de usuarios
    return usuario;
  } else {
    // Manejar el fallo de la solicitud HTTP
    throw Exception(
        'Fallo la solicitud HTTP con código ${response.statusCode}');
  }
}
