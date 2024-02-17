// ignore_for_file: file_names, use_full_hex_values_for_flutter_colors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

// Header el cual tendra el buscador y una card identificativa del usuario que este usando el aplicativo

class HeaderCategory extends StatelessWidget {
  const HeaderCategory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Navegar a la página anterior
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
        Text(
          "StayAway",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // Carta de perfil
        // Validación del ancho de pantalla
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const ProfileCard()
      ],
    );
  }
}

// Card donde estara el avatar y el nombre del usuario que este haciendo la sesión

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verica el tema actual
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      // Verifica si el usuario esta logueado
      child: FirebaseAuth.instance.currentUser == null
          ? Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 38,
                    height: 38,
                    color: primaryColor,
                    child: const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Validación del ancho de la pantalla
                if (!Responsive.isMobile(context))
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    child: Text("Iniciar Sesión"),
                  ),
              ],
            )
          : FutureBuilder(
              future: getUsuario(), // llama a todos los usuario
              builder: (context,
                  AsyncSnapshot<List<UsuariosModel>> usuarioEncabezado) {
                // Mientras se carga la información
                if (usuarioEncabezado.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Si el usuario es nulo
                if (usuarioEncabezado.data != null) {
                  return Row(
                    children: [
                      // Traer la información del usuario logueado
                      for (int index = 0;
                          index < usuarioEncabezado.data!.length;
                          index++)
                        if (FirebaseAuth.instance.currentUser!.email ==
                            usuarioEncabezado.data![index].correoElectronico)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: usuarioEncabezado.data![index].foto == ""
                                ? const Image(
                                    image: AssetImage("assets/images/foto.png"),
                                    height: 38,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    usuarioEncabezado.data![index].foto,
                                    height: 38,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                      // Traer la información del usuario logueado
                      for (int index = 0;
                          index < usuarioEncabezado.data!.length;
                          index++)
                        if (FirebaseAuth.instance.currentUser!.email ==
                            usuarioEncabezado.data![index].correoElectronico)
                          if (!Responsive.isMobile(context))
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2),
                              child: Text(usuarioEncabezado
                                  .data![index].nombreCompleto),
                            ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
    );
  }
}
