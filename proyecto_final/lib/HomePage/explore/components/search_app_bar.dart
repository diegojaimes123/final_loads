// ignore_for_file: use_full_hex_values_for_flutter_colors, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_final/LoginUsuario/Login/LoginAndRegister.dart';
import 'package:proyecto_final/buscador/buscador.dart';
import 'package:proyecto_final/controllers/MenuAppController.dart';
import 'package:proyecto_final/dashboard/screens/main/main_screen.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class SearchComponent extends StatefulWidget {
  final ThemeManager themeManager;

  const SearchComponent({super.key, required this.themeManager});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Responsive.isMobile(context)
              ? SingleChildScrollView(
                // Si es un dispositivo móvil, utiliza un desplazamiento horizontal.
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Imagen del logo de la aplicación.
                      const Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 120,
                        height: 80,
                      ),
                      Row(
                        children: [
                          ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: Container(
                                // Contenedor que envuelve un botón de búsqueda.
                                  color: primaryColor,
                                  child: IconButton(
                                      onPressed: () {
                                        _modalBuscador(
                                            context, widget.themeManager);
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      )))),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          InkWell(
                              onTap: () {
                                // Navegar a la pantalla de perfil o inicio de sesión.
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                      providers: [
                                        ChangeNotifierProvider(
                                          create: (context) =>
                                              MenuAppController(),
                                        ),
                                      ],
                                      child: MainScreenTodo(
                                          themeManager: widget.themeManager),
                                    ),
                                  ));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                            themeManager: widget.themeManager,
                                          )));
                                }
                              },
                              child: const ProfileCard()),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          InkWell(
                            onTap: () {
                              // Cambiar el tema claro/oscuro de la aplicación.
                              var newValue = ThemeMode.dark;

                              setState(() {
                                if (newValue == ThemeMode.dark) {
                                  newValue = ThemeMode.light;
                                  widget.themeManager.toggleTheme(
                                      widget.themeManager.themeMode ==
                                          newValue);
                                } else {
                                  newValue = ThemeMode.dark;
                                  widget.themeManager.toggleTheme(
                                      widget.themeManager.themeMode ==
                                          newValue);
                                }
                              });
                            },
                            child: const ThemeCard(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Row(
                // Si no es un dispositivo móvil, utiliza una fila normal.
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      // Imagen del logo de la aplicación.
                      image: AssetImage('assets/images/logo.png'),
                      width: 120,
                      height: 80,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            child: Container(
                              // Contenedor que envuelve un botón de búsqueda.
                                color: primaryColor,
                                child: IconButton(
                                    onPressed: () {
                                      _modalBuscador(
                                          context, widget.themeManager);
                                    },
                                    icon: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    )))),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        InkWell(
                            onTap: () {
                              // Navegar a la pantalla de perfil o inicio de sesión.
                              if (FirebaseAuth.instance.currentUser != null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MultiProvider(
                                    providers: [
                                      ChangeNotifierProvider(
                                        create: (context) =>
                                            MenuAppController(),
                                      ),
                                    ],
                                    child: MainScreenTodo(
                                        themeManager: widget.themeManager),
                                  ),
                                ));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                          themeManager: widget.themeManager,
                                        )));
                              }
                            },
                            child: const ProfileCard()),
                        const SizedBox(
                          width: defaultPadding,
                        ),
                        InkWell(
                          onTap: () {
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
                          child: const ThemeCard(),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema actual es oscuro.
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Contenedor que envuelve la tarjeta de perfil.
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
      // Fila que contiene elementos si el usuario no ha iniciado sesión.
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
                if (!Responsive.isMobile(context))
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    child: Text("Iniciar Sesión"),
                  ),
              ],
            )
          : FutureBuilder(
            // Llamada a la función getUsuario() para obtener datos de usuario.
              future: getUsuario(),
              // Constructor de la interfaz basado en la conexión asíncrona con getUsuario().
              builder: (context,
                  AsyncSnapshot<List<UsuariosModel>> usuarioEncabezado) {
                if (usuarioEncabezado.connectionState ==
                    ConnectionState.waiting) {
                      // Si la conexión está en espera, muestra un indicador de carga.
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Si se obtienen datos de usuario, construye la interfaz.
                if (usuarioEncabezado.data != null) {
                  // Fila que contiene elementos para usuarios autenticados.
                  return Row(
                    children: [
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
                      for (int index = 0;
                          index < usuarioEncabezado.data!.length;
                          index++)
                        if (FirebaseAuth.instance.currentUser!.email ==
                            usuarioEncabezado.data![index].correoElectronico)
                            // Esta sección solo aparece en los dispositivos de tamaño escritorio o tablet
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
                  // Si no se obtienen datos de usuario, muestra un indicador de carga.
                  return const CircularProgressIndicator();
                }
              }),
    );
  }
}

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema actual es oscuro
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: isDark ? secondaryColor : const Color(0xFFFF2F0F2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 38,
          height: 38,
          color: primaryColor,
          // cambia el icono dependiendo el tema seleccionado
          child: isDark
              ? SvgPicture.asset(
                  "assets/icons/Light.svg",
                  color: Colors.white,
                )
              : SvgPicture.asset(
                  "assets/icons/dark.svg",
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}

void _modalBuscador(BuildContext context, ThemeManager themeManager) {
  // Modal el cual comunica con el buscador
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          title: const Text(
            "StayAway",
            textAlign: TextAlign.center,
          ),
          // Contenido del buscador
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: StepWidget(themeManager: themeManager)),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                // Cierre del buscador
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar")),
              ],
            ),
          ],
        );
      });
}
