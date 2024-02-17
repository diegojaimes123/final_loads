// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/card.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/SitioVisitadoModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

// Contenedor el cual almacenara las cards de los sitios visitados del usuario

class VisitadoDetails extends StatefulWidget {
  // parametros los cuales reciben una lista de todos los sitios y otra con todos los usuario
  final ThemeManager themeManager;

  final List<SitioVisitadoModel> listasitios;

  final List<UsuariosModel> listausuarios;

  const VisitadoDetails({
    Key? key,
    required this.themeManager,
    required this.listasitios,
    required this.listausuarios,
  }) : super(key: key);

  @override
  State<VisitadoDetails> createState() => _VisitadoDetailsState();
}

class _VisitadoDetailsState extends State<VisitadoDetails> {
  @override
  void initState() {
    super.initState();

    // Recorre la lista de usuarios y sitios para eliminar las vistas que tienen más de 2 días
    for (var u = 0; u < widget.listausuarios.length; u++) {
      for (var x = 0; x < widget.listasitios.length; x++) {
        if (FirebaseAuth.instance.currentUser!.email ==
            widget.listausuarios[u].correoElectronico) {
          if (widget.listasitios[x].usuario == widget.listausuarios[u].id) {
            if (DateTime.now()
                    .difference(
                        DateTime.parse(widget.listasitios[x].fechaVista))
                    .inDays >=
                2) {
              eliminarVista(widget.listasitios[x].id);
            }
          }
        }
      }
    }
  }

  // Elimina una vista del servidor
  eliminarVista(int id) async {
    String url = "";

    // Configura la URL del servidor dependiendo de la plataforma (Android o no)
    if (UniversalPlatform.isAndroid) {
      url = "http://10.0.2.2:8000/api/SitioVisitado/";
    } else {
      url = "http://127.0.0.1:8000/api/SitioVisitado/";
    }

    // Realiza la solicitud de eliminación al servidor
    await http.delete(Uri.parse("$url$id/"));
  }

  @override
  Widget build(BuildContext context) {
    // Verifica tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
        height: 625,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sitios Visitados",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: defaultPadding),
              FutureBuilder(
                  future:
                      getSitioVisitado(), // llama todos los sitios visitados
                  builder: (context,
                      AsyncSnapshot<List<SitioVisitadoModel>> sitioVisitado) {
                    // Mientras se carga la información
                    if (sitioVisitado.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // verifica la información es nula
                    if (sitioVisitado.data != null) {
                      return FutureBuilder(
                          future: getUsuario(), // llama todos los usuarios
                          builder: (context,
                              AsyncSnapshot<List<UsuariosModel>> usuario) {
                            // Mientras se carga la información
                            if (usuario.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return FutureBuilder(
                                future: getSitios(), // llama todos los sitios
                                builder: (context,
                                    AsyncSnapshot<List<SitioModel>> sitio) {
                                  // Mientras se carga la información
                                  if (sitio.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1,
                                            childAspectRatio: 0.83),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    children: [
                                      for (var f = 0;
                                          f < sitioVisitado.data!.length;
                                          f++)
                                        for (var u = 0;
                                            u < usuario.data!.length;
                                            u++)
                                          for (var s = 0;
                                              s < sitio.data!.length;
                                              s++)
                                            // Comprueba si el usuario actual coincide con el usuario en la lista
                                            if (FirebaseAuth.instance
                                                    .currentUser!.email ==
                                                usuario
                                                    .data![u].correoElectronico)
                                              // Comprueba si el sitio visitado coincide con el sitio en la lista y si el usuario coincide con el usuario en la lista
                                              if ((sitioVisitado
                                                          .data![f].sitio ==
                                                      sitio.data![s].id) &&
                                                  (sitioVisitado
                                                          .data![f].usuario ==
                                                      usuario.data![u].id))
                                                // Si todas las condiciones son verdaderas, crea y devuelve un widget CardSite con datos específicos
                                                CardSite(
                                                    sitio: sitio.data![s],
                                                    usuario: usuario.data!,
                                                    themeManager:
                                                        widget.themeManager),
                                    ],
                                  );
                                });
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
