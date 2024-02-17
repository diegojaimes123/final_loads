// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/FormularioSitio/forms_provider.dart';
import 'package:proyecto_final/FormularioSitio/sitio/formulario_sitio.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/categories/screens/categoryPage.dart';
import 'package:proyecto_final/chat/homeChat.dart';
import 'package:proyecto_final/comentarios/screen/comentarioPage.dart';
import 'package:proyecto_final/loginActualizacionUsuario/actualizarDatos/LoginEditar.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class SideMenu extends StatefulWidget {
  final ThemeManager themeManager;

  const SideMenu({
    Key? key,
    required this.themeManager,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    // Verifica el tema actual de la aplicación
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: FutureBuilder(
          future: getUsuario(), // trae todos los usuarios
          builder: (context, AsyncSnapshot<List<UsuariosModel>> usuarioRol1) {
            // mientras carga la información
            if (usuarioRol1.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // valida si no hay datos
            if (usuarioRol1.data != null) {
              // Se trae la información del usuario para saber si este es administrador o no
              // a si mismo dependiendo de ello aparecen algunas funcionalidades
              return ListView(
                children: [
                  DrawerHeader(
                    child: Image.asset(
                      "assets/images/logo2.png",
                    ),
                  ),
                  // Botón del Home
                  DrawerListTile(
                    title: "Home",
                    svgSrc: "assets/icons/home.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreenPage(themeManager: widget.themeManager),
                        ),
                      );
                    },
                  ),
                  // Botón para actualizar el perfil del usuario y cambio de contraseña
                  for (int index = 0; index < usuarioRol1.data!.length; index++)
                    if (FirebaseAuth.instance.currentUser!.email ==
                        usuarioRol1.data![index].correoElectronico)
                      DrawerListTile(
                        title: "Mi Perfil",
                        svgSrc: "assets/icons/persona.svg",
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginEditarPage(
                                      themeManager: widget.themeManager,
                                      usuario: usuarioRol1.data![index],
                                    )),
                          );
                        },
                      ),
                  // Botón para ir al administrador de categorias
                  for (int index = 0; index < usuarioRol1.data!.length; index++)
                    if (FirebaseAuth.instance.currentUser!.email ==
                        usuarioRol1.data![index].correoElectronico)
                      if (usuarioRol1.data![index].rolAdmin != false)
                        DrawerListTile(
                          title: "Categorías",
                          svgSrc: "assets/icons/hotel.svg",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPage(
                                        themeManager: widget.themeManager,
                                      )),
                            );
                          },
                        ),
                  // Botón para el panel de comentarios
                  DrawerListTile(
                    title: "Comentarios",
                    svgSrc: "assets/icons/comentarios.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComentarioPage(
                                  themeManager: widget.themeManager,
                                )),
                      );
                    },
                  ),
                  // Chat en línea
                  DrawerListTile(
                    title: "Mis Chats",
                    svgSrc: "assets/icons/chat.svg",
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeChat(),
                        ),
                      );
                    },
                  ),
                  // Botón para ir al formulario de añadir sitios
                  DrawerListTile(
                    title: "Nuevo Sitio",
                    svgSrc: "assets/icons/addsitio.svg",
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider<FormsProvider>(
                                          create: (_) => FormsProvider())
                                    ],
                                    builder: (context, _) => SitioForm(
                                      themeManager: widget.themeManager,
                                    ),
                                  )));
                    },
                  ),
                  // Botón para cambiar de tema
                  DrawerListTile(
                    title: isDark ? "Modo Claro" : "Modo Oscuro",
                    svgSrc: isDark
                        ? "assets/icons/Light.svg"
                        : "assets/icons/dark.svg",
                    press: () {
                      // Cambiar el tema claro/oscuro de la aplicación.
                      var newValue = ThemeMode.dark;

                      setState(() {
                        if (newValue == ThemeMode.dark) {
                          newValue = ThemeMode.light;
                          widget.themeManager.toggleTheme(
                              widget.themeManager.themeMode == newValue);
                        } else {
                          newValue = ThemeMode.dark;
                          widget.themeManager.toggleTheme(
                              widget.themeManager.themeMode == newValue);
                        }
                      });
                    },
                  ),
                  // Botón para cerrar sesión de usuario en el aplicativo
                  DrawerListTile(
                    title: "Cerrar Sesión",
                    svgSrc: "assets/icons/logout.svg",
                    press: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreenPage(themeManager: widget.themeManager),
                        ),
                      );
                    },
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

// Clase para armar los botones del drawer
class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    // Verifica el tema del aplicativo
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // el diseño de este botón es tipo listTile el cual se ubica un icono y el enunciado y este list tile esta
    // envuelto en un evento para presionar y a este evento se le puede dar cualquier funcionalidad
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: isDark
            ? const ColorFilter.mode(Colors.white54, BlendMode.srcIn)
            : const ColorFilter.mode(primaryColor, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: isDark
            ? const TextStyle(color: Colors.white54)
            : const TextStyle(color: primaryColor),
      ),
    );
  }
}
