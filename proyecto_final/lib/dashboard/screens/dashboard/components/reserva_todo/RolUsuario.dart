// ignore_for_file: file_names, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import '../../../../../models/ip/local.dart';

class RolUsuario extends StatefulWidget {
  // Parametro que recibe el usuario
  final UsuariosModel usuario;

  final ThemeManager themeManager;

  const RolUsuario(
      {super.key, required this.usuario, required this.themeManager});

  @override
  State<RolUsuario> createState() => _RolUsuarioState();
}

class _RolUsuarioState extends State<RolUsuario> {
  // Lista de roles disponibles
  List roles = [
    Roles("Usuario", false),
    Roles("Administrador", true),
  ];

  // Controlador para el campo de texto del rol elegido
  late TextEditingController rolElegido =
      TextEditingController(text: widget.usuario.rolAdmin.toString());

  // Variable para asignar el rol del usuario
  String? rolValor;

  // Método para actualizar la información del usuario
  Future updateUser() async {
    try {
      final respuesta = await addUserEditDetails(
        widget.usuario.nombreCompleto,
        widget.usuario.tipoDocumento,
        widget.usuario.numeroDocumento,
        widget.usuario.correoElectronico,
        widget.usuario.telefono,
        widget.usuario.telefonoCelular,
        widget.usuario.idioma,
        widget.usuario.foto,
        widget.usuario.descripcion,
        widget.usuario.banco,
        widget.usuario.numeroCuenta,
        widget.usuario.daviplata,
        widget.usuario.fechaRegistro,
        rolElegido.text.trim(),
      );

      // Verificar si la actualización fue exitosa y navegar a la pantalla principal
      if (respuesta == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeScreenPage(
                  themeManager: widget.themeManager,
                )));
      }
    } catch (e) {
      print(e);
    }
  }

  // Método para realizar la solicitud de actualización del usuario
  Future<int> addUserEditDetails(
    String nombreCompleto,
    String tipoDocumento,
    String numeroDocumento,
    String email,
    String telefono,
    String celular,
    String idioma,
    String imagen,
    String descripcion,
    String banco,
    String numCuenta,
    String daviplata,
    String fecha,
    String rol,
  ) async {
    String url = "";

    // Construir la URL de la API según la plataforma
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Usuarios/";
    } else {
      url = "http://127.0.0.1:8000/api/Usuarios/";
    }

    // Encabezados y cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "nombreCompleto": nombreCompleto,
      "tipoDocumento": tipoDocumento,
      "numeroDocumento": numeroDocumento,
      "correoElectronico": email,
      "telefono": telefono,
      "telefonoCelular": celular,
      "idioma": idioma,
      "foto": imagen,
      "rolAdmin": rol,
      "descripcion": descripcion,
      "banco": banco,
      "numeroCuenta": numCuenta,
      "daviplata": daviplata,
      "fechaRegistro": fecha,
    };

    int resultado = 0;

    try {
      // Realizar la solicitud HTTP PUT
      final response = await http.put(
        Uri.parse("$url${widget.usuario.id}/"),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el estado con el código de respuesta
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      print(e);
    }

    return resultado;
  }

  // Liberar recursos al destruir el widget
  @override
  void dispose() {
    rolElegido.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Cambio de rol en el aplicativo",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: 250,
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              Image.asset(
                "assets/images/logo.png",
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              // DropdownButton para ver los roles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    // Configuración del menú desplegable
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Rol',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: roles
                        .map((item) => DropdownMenuItem<String>(
                              value: item.valor.toString(),
                              child: Text(
                                item.titulo,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: rolElegido.text, // Valor seleccionado actualmente
                    onChanged: (String? value) {
                      // Manejador de eventos cuando se selecciona un nuevo valor
                      setState(() {
                        rolValor = value;
                        rolElegido.text = rolValor!;
                      });
                      if (rolValor == null || rolValor!.isEmpty) {
                        return;
                      }
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.white,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Botones de la barra inferior
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancelar")),
            ElevatedButton(
                onPressed: () {
                  // Función para actualizar el usuario
                  updateUser();
                },
                child: const Text("Guardar")),
          ],
        ),
      ],
    );
  }
}

// Clase para representar un rol con un título y un valor booleano
class Roles {
  final String? titulo;
  final bool valor;

  Roles(this.titulo, this.valor);
}
