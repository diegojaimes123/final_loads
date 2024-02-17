// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/card.dart';
import 'package:proyecto_final/models/FavoritoModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// Contenedor el cual almacenara las cards de los sitios favoritos del usuario

class FavoritoDetails extends StatelessWidget {
  final ThemeManager themeManager;

  const FavoritoDetails({
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
      child: SizedBox(
        height: 625,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sitios Favoritos",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: defaultPadding),
              FutureBuilder(
                  future: getFavorito(), // Trae todos los sitios favoritos
                  builder:
                      (context, AsyncSnapshot<List<FavoritoModel>> favorito) {
                    //Mientras se carga la información
                    if (favorito.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    // Verifica si los datos son nulos
                    if (favorito.data != null) {
                      return FutureBuilder(
                          future: getUsuario(), // llama a todos los usuarios
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
                                future: getSitios(), // llama a todos los sitios
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
                                          f < favorito.data!.length;
                                          f++)
                                        for (var u = 0;
                                            u < usuario.data!.length;
                                            u++)
                                          for (var s = 0;
                                              s < sitio.data!.length;
                                              s++)
                                            // Verifica el usuario logueado
                                            if (FirebaseAuth.instance
                                                    .currentUser!.email ==
                                                usuario
                                                    .data![u].correoElectronico)
                                              // mira los sitios favoritos del usuario que esta logueado
                                              if ((favorito.data![f].sitio ==
                                                      sitio.data![s].id) &&
                                                  (favorito.data![f].usuario ==
                                                      usuario.data![u].id))
                                                // Crea y devuelve un widget CardSite con datos específicos
                                                CardSite(
                                                    sitio: sitio.data![s],
                                                    usuario: usuario.data!,
                                                    themeManager: themeManager),
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
