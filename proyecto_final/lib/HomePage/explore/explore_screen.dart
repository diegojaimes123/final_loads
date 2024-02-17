import 'package:flutter/material.dart';
import 'package:proyecto_final/models/CategoriaModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import '../explore/components/search_app_bar.dart';
import '../../card.dart';

class ExploreScreen extends StatefulWidget {
  final ThemeManager themeManager;

  const ExploreScreen({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // Buscador
          SearchComponent(
            themeManager: widget.themeManager,
          ),
          // Cuerpo del homepage
          Expanded(
            child: BodyHome(
              themeManager: widget.themeManager,
            ),
          ),
        ],
      ),
    );
  }
}

class BodyHome extends StatelessWidget {
  final ThemeManager themeManager;

  const BodyHome({
    Key? key,
    required this.themeManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Llamada a la función getCategoria() para obtener datos de categorías.
      future: getCategoria(),
      // Constructor de la interfaz basado en la conexión asíncrona con getCategoria().
      builder: (context, AsyncSnapshot<List<CategoriaModel>> categoriaHeader) {
        // Si la conexión está en espera, muestra un indicador de carga.
        if (categoriaHeader.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (categoriaHeader.data != null) {
          // Si se obtienen datos de categoría, construye la interfaz con pestañas y vistas.
          return DefaultTabController(
            // Longitud de las pestañas basada en la cantidad de categorías.
            length: categoriaHeader.data!.length,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  // Contenedor que alberga la barra de pestañas.
                  child: TabBar(
                    indicatorColor: primaryColor,
                    isScrollable: true,
                    tabs: [
                      for (int index = 0;
                          index < categoriaHeader.data!.length;
                          index++)
                        Container(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 4, top: 4),
                          // Contenedor que alberga el ícono y el nombre de la categoría.
                          child: Column(
                            children: [
                              Image.network(
                                categoriaHeader.data![index].icono,
                                width: 24,
                                height: 24,
                              ),
                              Text(
                                categoriaHeader.data![index].nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  // Contenedor que alberga el ícono y el nombre de la categoría.
                  child: TabBarView(
                    children: [
                      for (int index = 0;
                          index < categoriaHeader.data!.length;
                          index++)
                        // Contenedor que alberga la rejilla de sitios.
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: FutureBuilder(
                            // Llamada a la función getUsuario() para obtener datos de usuarios.
                            future: getUsuario(),
                            // Constructor de la interfaz basado en la conexión asíncrona con getUsuario().
                            builder: (context,
                                AsyncSnapshot<List<UsuariosModel>> usuario) {
                              // Si la conexión está en espera, muestra un indicador de carga.
                              if (usuario.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return FutureBuilder(
                                // Llamada a la función getSitios() para obtener datos de sitios.
                                future: getSitios(),
                                // Constructor de la interfaz basado en la conexión asíncrona con getSitios().
                                builder: (context,
                                    AsyncSnapshot<List<SitioModel>> sitio) {
                                  if (sitio.connectionState ==
                                      ConnectionState.waiting) {
                                    // Si la conexión está en espera, muestra un indicador de carga.
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  // Rejilla que muestra tarjetas de sitios.
                                  return GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      // Número de columnas basado en el tipo de dispositivo.
                                      crossAxisCount:
                                          Responsive.isMobile(context)
                                              ? 1
                                              : Responsive.isTablet(context)
                                                  ? 3
                                                  : 4,
                                      childAspectRatio: 0.83,
                                    ),
                                    children: [
                                      // Tarjetas de sitios filtradas por la categoría actual.
                                      for (int index2 = 0;
                                          index2 < sitio.data!.length;
                                          index2++)
                                        if (categoriaHeader
                                                .data![index].nombre ==
                                            sitio
                                                .data![index2].categoria.nombre)
                                          CardSite(
                                            sitio: sitio.data![index2],
                                            usuario: usuario.data!,
                                            themeManager: themeManager,
                                          ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          // Si no se obtienen datos de categoría, muestra un indicador de carga.
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
