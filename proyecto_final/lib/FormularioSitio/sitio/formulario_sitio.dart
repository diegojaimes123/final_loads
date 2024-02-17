// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/FormularioSitio/sitio/pantallas.dart';
import 'package:proyecto_final/FormularioSitio/sitio/servicios/servicios_screen.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

import '../../models/ip/local.dart';

class SitioForm extends StatefulWidget {
  final ThemeManager themeManager;

  const SitioForm({super.key, required this.themeManager});

  @override
  State<SitioForm> createState() => _SitioFormState();
}

class _SitioFormState extends State<SitioForm> {
  // Controlador de páginas y estado actual
  PageController? controller;
  int currentIndex = 0;

  // Lista para almacenar objetos Pantallas
  List<Pantallas> listaPantallas = <Pantallas>[];

  @override
  void initState() {
    // Inicialización del controlador de páginas y llamada al método _pantallasSitio.
    controller = PageController(initialPage: 0);
    super.initState();
    _pantallasSitio();
  }

  // Controladores para varios campos de texto utilizados en el formulario
  TextEditingController usuario = TextEditingController();
  TextEditingController categoria = TextEditingController();
  TextEditingController titulo = TextEditingController();
  TextEditingController numeroHuespedes = TextEditingController();
  TextEditingController numeroCamas = TextEditingController();
  TextEditingController numeroBanhos = TextEditingController();
  TextEditingController descripcionSitio = TextEditingController();
  TextEditingController valorNoche = TextEditingController();
  TextEditingController lugar = TextEditingController();
  TextEditingController descripcionLugar = TextEditingController();
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  TextEditingController continente = TextEditingController();
  TextEditingController valorLimpieza = TextEditingController();
  TextEditingController politica = TextEditingController();
  TextEditingController habitaciones = TextEditingController();
  List<String> tituloHabitaciones = [];
  List<String> descripcionHabitaciones = [];
  List<String> imagenes = [];
  TextEditingController reglas = TextEditingController();
  TextEditingController seguridad = TextEditingController();
  List<String> nombreServicio = [];
  List<String> iconoServicio = [];
  List<String> descipcionServicio = [];

  // Clave global para el formulario
  GlobalKey<FormState> llave = GlobalKey<FormState>();

  // Texto para el botón de enviar
  String botonG = 'Guardar';

  // Método para guardar los datos del sitio
  void saveSite() async {
    // Listas para almacenar datos de usuarios y sitios
    List<UsuariosModel> usuariosLista = [];
    List<int> sitioLista = [];
    // URLs para diferentes puntos finales de la API
    String url = "";
    String url1 = "";
    String url2 = "";
    String url3 = "";
    String url4 = "";
    String url5 = "";
    String url6 = "";
    int resultadoSitio = 0;
    int resultadoImagen = 0;
    int resultadoRegla = 0;
    int resultadoSeguridad = 0;
    int resultadoServicio = 0;

    // Comprobación de la plataforma para obtener la URL de localhost correcta
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Sitios/";
    } else {
      url = "http://127.0.0.1:8000/api/Sitios/";
    }

    if (UniversalPlatform.isAndroid) {
      url1 = "http://$ip_ideapat:8000/api/Usuarios/";
    } else {
      url1 = "http://127.0.0.1:8000/api/Usuarios/";
    }

    if (UniversalPlatform.isAndroid) {
      url2 = "http://$ip_ideapat:8000/api/Habitacion/";
    } else {
      url2 = "http://127.0.0.1:8000/api/Habitacion/";
    }

    if (UniversalPlatform.isAndroid) {
      url3 = "http://$ip_ideapat:8000/api/Imagen/";
    } else {
      url3 = "http://127.0.0.1:8000/api/Imagen/";
    }

    if (UniversalPlatform.isAndroid) {
      url4 = "http://$ip_ideapat:8000/api/Reglas/";
    } else {
      url4 = "http://127.0.0.1:8000/api/Reglas/";
    }

    if (UniversalPlatform.isAndroid) {
      url5 = "http://$ip_ideapat:8000/api/Seguridad/";
    } else {
      url5 = "http://127.0.0.1:8000/api/Seguridad/";
    }

    if (UniversalPlatform.isAndroid) {
      url6 = "http://$ip_ideapat:8000/api/Servicios/";
    } else {
      url6 = "http://127.0.0.1:8000/api/Servicios/";
    }

    // Solicitud GET para obtener datos de usuarios
    final response1 = await http.get(Uri.parse(url1));

    // Comprobación del estado de la respuesta y procesamiento de los datos
    if (response1.statusCode == 200) {
      usuariosLista.clear();

      // Decodificar la respuesta JSON
      String responseBodyUtf8 = utf8.decode(response1.bodyBytes);
      List<dynamic> decodedData = jsonDecode(responseBodyUtf8);

      // Iterar a través de todos los usuarios en decodedData
      for (var userData in decodedData) {
        // Construir el modelo de usuario para cada usuario en la lista
        usuariosLista.add(UsuariosModel(
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

      // Buscar el ID del usuario actual
      for (var o in usuariosLista) {
        if (FirebaseAuth.instance.currentUser!.email == o.correoElectronico) {
          setState(() {
            usuario.text = o.id.toString();
          });
        }
      }
    } else {
      // Manejar el fallo de la solicitud HTTP
      throw Exception(
          'Fallo la solicitud HTTP con código ${response1.statusCode}');
    }

    // Cálculo de la comisión como el 20% del valor de la noche y convertido a entero
    int comision = (int.parse(valorNoche.text) * 0.20).toInt();

    // Encabezados y cuerpo de datos para la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "usuario": usuario.text.trim(),
      "titulo": titulo.text.trim(),
      "numHuespedes": numeroHuespedes.text.trim(),
      "numCamas": numeroCamas.text.trim(),
      "numBanos": numeroBanhos.text.trim(),
      "descripcion": descripcionSitio.text.trim(),
      "valorNoche": valorNoche.text.trim(),
      "lugar": lugar.text.trim(),
      "desLugar": descripcionLugar.text.trim(),
      "latitud": latitud.text.trim(),
      "longitud": longitud.text.trim(),
      "continente": continente.text.trim(),
      "valorLimpieza": valorLimpieza.text.trim(),
      "comision": comision,
      "politica": politica.text.trim(),
      "categoria": categoria.text.trim(),
    };

    try {
      // Realizar la solicitud HTTP POST para guardar datos del sitio
      final responseSitio = await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el estado con el código de respuesta de la solicitud
      setState(() {
        resultadoSitio = responseSitio.statusCode;
      });
    } catch (e) {
      // Manejar cualquier excepción que pueda ocurrir durante la solicitud
      print(e);
    }

    // Verificar si la solicitud del sitio fue exitosa
    if (resultadoSitio == 201) {
      // Realizar una solicitud GET para obtener información del sitio recién creado
      final responseSite = await http.get(Uri.parse(url));

      // Verificar si la solicitud GET fue exitosa
      if (responseSite.statusCode == 200) {
        sitioLista.clear();

        // Decodificar la respuesta JSON
        String responseSiteUtf8 = utf8.decode(responseSite.bodyBytes);
        List<dynamic> siteData = jsonDecode(responseSiteUtf8);

        // Iterar a través de los datos del sitio y agregar el ID a la lista
        for (var item in siteData) {
          sitioLista.add(item['id'] ?? 0);
        }
      }

      // Encabezados y cuerpo de datos para la solicitud HTTP de Reglas
      final Map<String, String> dataHeaderRegla = {
        'Content-Type': 'application/json; charset-UTF=8',
      };

      final Map<String, dynamic> dataBodyRegla = {
        "descripcion": reglas.text.trim(),
        "sitio": sitioLista.last.toString(),
      };

      try {
        // Realizar la solicitud HTTP POST para guardar datos de reglas
        final responseRegla = await http.post(
          Uri.parse(url4),
          headers: dataHeaderRegla,
          body: json.encode(dataBodyRegla),
        );

        // Actualizar el estado con el código de respuesta de la solicitud de reglas
        setState(() {
          resultadoRegla = responseRegla.statusCode;
        });
      } catch (e) {
        // Manejar cualquier excepción que pueda ocurrir durante la solicitud
        print(e);
      }

      // Configuración de encabezados y cuerpo de datos para la solicitud de seguridad
      final Map<String, String> dataHeaderSeguridad = {
        'Content-Type': 'application/json; charset-UTF=8',
      };

      final Map<String, dynamic> dataBodySeguridad = {
        "descripcion": seguridad.text.trim(),
        "sitio": sitioLista.last.toString(),
      };

      try {
        // Realizar la solicitud HTTP para seguridad
        final responseSeguridad = await http.post(
          Uri.parse(url5),
          headers: dataHeaderSeguridad,
          body: json.encode(dataBodySeguridad),
        );

        // Actualizar el estado con el código de respuesta
        setState(() {
          resultadoSeguridad = responseSeguridad.statusCode;
        });
      } catch (e) {
        // Capturar y manejar cualquier error durante la solicitud
        print(e);
      }

      // Verificar si habitaciones.text es "true" para procesar información adicional
      if (habitaciones.text == "true") {
        // Iterar sobre las habitaciones y realizar solicitudes HTTP individuales
        for (var h = 0; h < tituloHabitaciones.length; h++) {
          final Map<String, String> dataHeaderHabitacion = {
            'Content-Type': 'application/json; charset-UTF=8',
          };

          final Map<String, dynamic> dataBodyHabitacion = {
            "titulo": tituloHabitaciones[h],
            "descripcion": descripcionHabitaciones[h],
            "sitio": sitioLista.last.toString(),
          };

          try {
            // Realizar la solicitud HTTP para habitaciones
            await http.post(
              Uri.parse(url2),
              headers: dataHeaderHabitacion,
              body: json.encode(dataBodyHabitacion),
            );
          } catch (e) {
            // Capturar y manejar cualquier error durante la solicitud
            print(e);
          }
        }
      }

      // Iterar sobre las imágenes y realizar solicitudes HTTP individuales
      for (var r in imagenes) {
        final Map<String, String> dataHeaderImagen = {
          'Content-Type': 'application/json; charset-UTF=8',
        };

        final Map<String, dynamic> dataBodyImagen = {
          "direccion": r,
          "sitio": sitioLista.last.toString(),
        };

        try {
          // Realizar la solicitud HTTP para imágenes
          final responseImagen = await http.post(
            Uri.parse(url3),
            headers: dataHeaderImagen,
            body: json.encode(dataBodyImagen),
          );

          // Actualizar el estado con el código de respuesta
          setState(() {
            resultadoImagen = responseImagen.statusCode;
          });
        } catch (e) {
          // Capturar y manejar cualquier error durante la solicitud
          print(e);
        }
      }

      // Iterar sobre los servicios y realizar solicitudes HTTP individuales
      for (var l = 0; l < nombreServicio.length; l++) {
        final Map<String, String> dataHeaderServicio = {
          'Content-Type': 'application/json; charset-UTF=8',
        };

        final Map<String, dynamic> dataBodyServicio = {
          "icono": iconoServicio[l],
          "nombre": nombreServicio[l],
          "descripcion": descipcionServicio[l],
          "sitio": sitioLista.last.toString(),
        };

        try {
          // Realizar la solicitud HTTP para servicios
          final responseServicio = await http.post(
            Uri.parse(url6),
            headers: dataHeaderServicio,
            body: json.encode(dataBodyServicio),
          );

          // Actualizar el estado con el código de respuesta
          setState(() {
            resultadoServicio = responseServicio.statusCode;
          });
        } catch (e) {
          // Capturar y manejar cualquier error durante la solicitud
          print(e);
        }
      }
    }

    // Verificar si todas las solicitudes fueron exitosas antes de navegar a la pantalla principal
    if (resultadoSitio == 201 &&
        resultadoRegla == 201 &&
        resultadoSeguridad == 201 &&
        resultadoImagen == 201 &&
        resultadoServicio == 201) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HomeScreenPage(
            themeManager: widget.themeManager,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Liberar recursos al cerrar el widget
    categoria.dispose();
    titulo.dispose();
    numeroHuespedes.dispose();
    numeroCamas.dispose();
    numeroBanhos.dispose();
    descripcionSitio.dispose();
    valorNoche.dispose();
    lugar.dispose();
    descripcionLugar.dispose();
    latitud.dispose();
    longitud.dispose();
    continente.dispose();
    valorLimpieza.dispose();
    politica.dispose();
    habitaciones.dispose();
    reglas.dispose();
    seguridad.dispose();
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, responsive) {
        // Validar si el ancho de la pantalla es mayor o igual a 1000
        if (responsive.maxWidth >= 1000) {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/fondo1.webp'),
                          fit: BoxFit.cover)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Center(
                        child: Container(
                          width: 500,
                          decoration: BoxDecoration(
                            color: const Color(0x2ADAD7D7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: PageView.builder(
                                      controller: controller,
                                      itemCount: listaPantallas.length,
                                      onPageChanged: (int index) {
                                        // Actualizar el índice de la página actual cuando cambia
                                        if (index >= currentIndex) {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        }
                                      },
                                      itemBuilder: (context, index) {
                                        // Construir cada pantalla en el PageView
                                        return SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            listaPantallas[index].pantalla,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ));
                                      })),
                              Expanded(
                                  flex: -1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: List.generate(
                                                  listaPantallas.length,
                                                  (index) =>
                                                      buildDot(index, context)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Lógica para manejar el tap en el botón de Continuar
                                              //if (llave.currentState!.validate()) {
                                              if (currentIndex ==
                                                      listaPantallas.length -
                                                          1 &&
                                                  imagenes.isNotEmpty &&
                                                  nombreServicio.isNotEmpty &&
                                                  politica.text != "false" &&
                                                  llave.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  botonG = "Cargando";
                                                });
                                                // Función para guardar el sitio
                                                saveSite();
                                              }
                                              controller!.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                              // }
                                            },
                                            child: Container(
                                              width: 90,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFAD974F),
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(
                                                      1.0,
                                                      1.0,
                                                    ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 2.0,
                                                  ), //BoxShadow
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  currentIndex == 4
                                                      ? botonG
                                                      : 'Continuar',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white
                                                      //fontFamily: 'CedarvilleCursive'
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ))));
          // Validar si el ancho de la pantalla es igual a 280
        } else if (responsive.maxWidth == 280) {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/fondo1.webp'),
                          fit: BoxFit.cover)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Center(
                        child: Container(
                          width: 500,
                          decoration: BoxDecoration(
                            color: const Color(0x2ADAD7D7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: PageView.builder(
                                      controller: controller,
                                      itemCount: listaPantallas.length,
                                      onPageChanged: (int index) {
                                        // Actualizar el índice de la página actual cuando cambia
                                        if (index >= currentIndex) {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        }
                                      },
                                      itemBuilder: (context, index) {
                                        // Construir cada pantalla en el PageView
                                        return SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            listaPantallas[index].pantalla,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ));
                                      })),
                              Expanded(
                                  flex: -1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: List.generate(
                                                  listaPantallas.length,
                                                  (index) =>
                                                      buildDot(index, context)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Lógica para manejar el tap en el botón de Continuar
                                              //if (llave.currentState!.validate()) {
                                              if (currentIndex ==
                                                      listaPantallas.length -
                                                          1 &&
                                                  imagenes.isNotEmpty &&
                                                  nombreServicio.isNotEmpty &&
                                                  politica.text != "false" &&
                                                  llave.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  botonG = "Cargando";
                                                });
                                                // Función para guardar el sitio
                                                saveSite();
                                              }
                                              controller!.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                              // }
                                            },
                                            child: Container(
                                              width: 90,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFAD974F),
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(
                                                      1.0,
                                                      1.0,
                                                    ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 2.0,
                                                  ), //BoxShadow
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  currentIndex == 4
                                                      ? botonG
                                                      : 'Continuar',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white
                                                      //fontFamily: 'CedarvilleCursive'
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ))));
          // Validar si el ancho de la pantalla es mayor o igual a 700 o si es menor o igual a 999
        } else if (responsive.maxWidth >= 700 || responsive.maxWidth <= 999) {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/fondo1.webp'),
                          fit: BoxFit.cover)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 50),
                      child: Center(
                        child: Container(
                          width: 600,
                          decoration: BoxDecoration(
                            color: const Color(0x2ADAD7D7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: PageView.builder(
                                      controller: controller,
                                      itemCount: listaPantallas.length,
                                      onPageChanged: (int index) {
                                        // Actualizar el índice de la página actual cuando cambia
                                        if (index >= currentIndex) {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        }
                                      },
                                      itemBuilder: (context, index) {
                                        // Construir cada pantalla en el PageView
                                        return SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            listaPantallas[index].pantalla,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ));
                                      })),
                              Expanded(
                                  flex: -1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: List.generate(
                                                  listaPantallas.length,
                                                  (index) =>
                                                      buildDot(index, context)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Lógica para manejar el tap en el botón de Continuar
                                              //if (llave.currentState!.validate()) {
                                              if (currentIndex ==
                                                      listaPantallas.length -
                                                          1 &&
                                                  imagenes.isNotEmpty &&
                                                  nombreServicio.isNotEmpty &&
                                                  politica.text != "false" &&
                                                  llave.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  botonG = "Cargando";
                                                });
                                                // Función para guardar el sitio
                                                saveSite();
                                              }
                                              controller!.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                              // }
                                            },
                                            child: Container(
                                              width: 90,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFAD974F),
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(
                                                      1.0,
                                                      1.0,
                                                    ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 2.0,
                                                  ), //BoxShadow
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  currentIndex == 4
                                                      ? botonG
                                                      : 'Continuar',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white
                                                      //fontFamily: 'CedarvilleCursive'
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ))));
          // Vista por defecto
        } else {
          return Scaffold(
              backgroundColor: Colors.black,
              body: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/fondo1.webp'),
                          fit: BoxFit.cover)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Center(
                        child: Container(
                          width: 500,
                          decoration: BoxDecoration(
                            color: const Color(0x2ADAD7D7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 6,
                                  child: PageView.builder(
                                      controller: controller,
                                      itemCount: listaPantallas.length,
                                      onPageChanged: (int index) {
                                        // Actualizar el índice de la página actual cuando cambia
                                        if (index >= currentIndex) {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        } else {
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        }
                                      },
                                      itemBuilder: (context, index) {
                                        // Construir cada pantalla en el PageView
                                        return SingleChildScrollView(
                                            child: Column(
                                          children: [
                                            listaPantallas[index].pantalla,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ));
                                      })),
                              Expanded(
                                  flex: -1,
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Row(
                                              children: List.generate(
                                                  listaPantallas.length,
                                                  (index) =>
                                                      buildDot(index, context)),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              // Lógica para manejar el tap en el botón de Continuar
                                              //if (llave.currentState!.validate()) {
                                              if (currentIndex ==
                                                      listaPantallas.length -
                                                          1 &&
                                                  imagenes.isNotEmpty &&
                                                  nombreServicio.isNotEmpty &&
                                                  politica.text != "false" &&
                                                  llave.currentState!
                                                      .validate()) {
                                                setState(() {
                                                  botonG = "Cargando";
                                                });
                                                // Función para guardar el sitio
                                                saveSite();
                                              }
                                              controller!.nextPage(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOut);
                                              // }
                                            },
                                            child: Container(
                                              width: 90,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFAD974F),
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(
                                                      1.0,
                                                      1.0,
                                                    ),
                                                    blurRadius: 8.0,
                                                    spreadRadius: 2.0,
                                                  ), //BoxShadow
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  currentIndex == 4
                                                      ? botonG
                                                      : 'Continuar',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white
                                                      //fontFamily: 'CedarvilleCursive'
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                      ))));
        }
      },
    );
  }

// Método para definir las pantallas del sitio
  void _pantallasSitio() {
    var lista = <Pantallas>[
      // Primera pantalla con formulario
      Pantallas(
          pantalla: Form(
        key: llave,
        child: PantallaPageOne(
            categoriaController: categoria,
            titulo: titulo,
            numeroHuespedes: numeroHuespedes,
            numeroCamas: numeroCamas,
            numeroBanhos: numeroBanhos,
            descripcionSitio: descripcionSitio),
      )),
      // Segunda pantalla con formulario
      Pantallas(
          pantalla: Form(
        key: llave,
        child: PantallaPageTwo(
            valorNoche: valorNoche,
            lugar: lugar,
            descripcionLugar: descripcionLugar,
            latitud: latitud,
            longitud: longitud,
            continenteController: continente),
      )),
      // Tercera pantalla con formulario
      Pantallas(
          pantalla: Form(
        key: llave,
        child: PantallaPageThree(
            valorLimpieza: valorLimpieza,
            politica: politica,
            habitaciones: habitaciones,
            tituloHabitaciones: tituloHabitaciones,
            descripcionHabitaciones: descripcionHabitaciones,
            imagenes: imagenes),
      )),
      // Cuarta pantalla con servicios
      Pantallas(
          pantalla: Servicios(
        nombreServicio: nombreServicio,
        iconoServicio: iconoServicio,
        descipcionServicio: descipcionServicio,
      )),
      // Quinta pantalla con formulario
      Pantallas(
          pantalla: Form(
        key: llave,
        child: PantallaPageFour(reglas: reglas, seguridad: seguridad),
      ))
      //Pantallas(pantalla: SelectedItemsView(selectedItems))
    ];

    // Actualizar el estado con la lista de pantallas
    setState(() {
      listaPantallas = lista;
    });
  }

  // Método para construir los indicadores de página (puntos)
  AnimatedContainer buildDot(int Index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 8,
      width: currentIndex == Index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == Index ? Colors.grey : Colors.grey),
    );
  }
}

// Clase para representar cada pantalla
class Pantallas {
  Widget pantalla;

  Pantallas({required this.pantalla});
}
