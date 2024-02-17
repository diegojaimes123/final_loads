// ignore_for_file: file_names, use_full_hex_values_for_flutter_colors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/sitioAnf.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// Contenedor el cual encapsula la vista previa de todos los sitios del anfitrión

class MisSitios extends StatelessWidget {
  final ThemeManager themeManager;

  const MisSitios({
    Key? key,
    required this.themeManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mis Sitios",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 550,
            width: 400,
            child: FutureBuilder(
                future: getUsuario(), // trae todos los usuarios
                builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario) {
                  // Mientras carga la información
                  if (usuario.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return FutureBuilder(
                      future: getSitios(), // traer todos los sitios
                      builder:
                          (context, AsyncSnapshot<List<SitioModel>> sitio) {
                        // Mientras carga la información
                        if (sitio.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Verifica si la información es nula
                        if (sitio.data != null) {
                          return SingleChildScrollView(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                for (int index = 0;
                                    index < sitio.data!.length;
                                    index++)
                                  for (int index2 = 0;
                                      index2 < usuario.data!.length;
                                      index2++)
                                    // Verifica si el usuario esta logueado
                                    if (FirebaseAuth
                                            .instance.currentUser!.email ==
                                        usuario.data![index2].correoElectronico)
                                      // Verifica todos los sitios que son propiedad del usuario
                                      if (usuario.data![index2].id ==
                                          sitio.data![index].usuario)
                                        // Llama a la carta con la información del sitio
                                        SitioAnfCard(
                                          sitio: sitio.data![index],
                                          favorito: false,
                                          usuario: usuario.data!,
                                          themeManager: themeManager,
                                        ),
                              ],
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                }),
          ),
        ],
      ),
    );
  }
}
