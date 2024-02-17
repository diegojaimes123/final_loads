// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chat/Pages/chatPageA.dart';
import 'package:proyecto_final/chat/Pages/chatPageAm.dart';
import 'package:proyecto_final/chat/Pages/chatPageMu.dart';
import 'package:proyecto_final/chat/Pages/chatPageU.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema es oscuro
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Número inicial de pestañas
    int numTabs = 3;

    return FutureBuilder(
        future: getUsuario(), // Llama a todos los usuarios
        builder: (context, AsyncSnapshot<List<UsuariosModel>> usuario) {
          if (usuario.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos del usuario
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Verifica el rol del usuario para determinar el número de pestañas
          for (int index = 0; index < usuario.data!.length; index++) {
            if (FirebaseAuth.instance.currentUser!.email ==
                usuario.data![index].correoElectronico) {
              if (usuario.data![index].rolAdmin != false) {
                numTabs = 4;
              }
            }
          }

          // Construye la interfaz de usuario con pestañas
          return DefaultTabController(
            length: numTabs,
            child: Scaffold(
              appBar: AppBar(
                // Botón de retroceso en la barra de navegación
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: primaryColor,
                    )),
                backgroundColor: isDark ? secondaryColor : Colors.white,
                // Logo en el centro de la barra de navegación
                title: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 50,
                  height: 50,
                ),
                centerTitle: true,
                // Pestañas en la parte inferior de la barra de navegación
                bottom: TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  tabs: [
                    const Tab(
                      text: "Administradores",
                    ),
                    const Tab(
                      text: "Anfitriones",
                    ),
                    const Tab(
                      text: "Mis Huespedes",
                    ),
                    // Añade la pestaña de "Usuarios" solo si el usuario actual es un administrador
                    for (int index = 0; index < usuario.data!.length; index++)
                      if (FirebaseAuth.instance.currentUser!.email ==
                          usuario.data![index].correoElectronico)
                        if (usuario.data![index].rolAdmin != false)
                          const Tab(
                            text: "Usuarios",
                          ),
                  ],
                ),
              ),
              // Cuerpo de la pantalla con vistas de pestañas
              body: TabBarView(
                children: [
                  const ChatPageAm(),
                  const ChatPageA(),
                  const ChatPageMu(),
                  // Añade la pestaña de "Usuarios" solo si el usuario actual es un administrador
                  for (int index = 0; index < usuario.data!.length; index++)
                    if (FirebaseAuth.instance.currentUser!.email ==
                        usuario.data![index].correoElectronico)
                      if (usuario.data![index].rolAdmin != false)
                        const ChatPageU(),
                ],
              ),
            ),
          );
        });
  }
}
