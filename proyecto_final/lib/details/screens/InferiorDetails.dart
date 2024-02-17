// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:proyecto_final/models/ReglaModel.dart';
import 'package:proyecto_final/models/SeguridadModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class InferiorDetails extends StatefulWidget {
  // parametros para poder realizar y llamar funciones en la vista de detalles
  final SitioModel sitio;

  const InferiorDetails({
    super.key,
    required this.sitio,
  });

  @override
  State<InferiorDetails> createState() => _InferiorDetailsState();
}

class _InferiorDetailsState extends State<InferiorDetails> {
  // Elevaciones para diferentes componentes
  double elevacion = 3;
  double elevacion2 = 3;
  double elevacion3 = 3;

  // Modelos para detalles de reglas y seguridad
  late ReglaModel reglaSitio;
  late SeguridadModel seguridadSitio;

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema actual es oscuro
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Diseño para escritorio y tablet
          if (Responsive.isDesktop(context) || Responsive.isTablet(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contenedor para mostrar reglas
                FutureBuilder(
                    future: getRegla(),
                    builder: (context, AsyncSnapshot<List<ReglaModel>> regla) {
                      // Indicador de carga mientras se obtienen los datos
                      if (regla.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Extraer detalles de reglas para el sitio actual
                      for (var x = 0; x < regla.data!.length; x++) {
                        if (widget.sitio.id == regla.data![x].sitio) {
                          reglaSitio = regla.data![x];
                        }
                      }

                      // Contenedor con información de reglas
                      return InkWell(
                        onTap: () {
                          _modalRegla(context, reglaSitio);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: isDark ? secondaryColor : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, elevacion),
                                ),
                              ]),
                          child: const Text(
                            "Reglas de la casa",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      );
                    }),
                // Contenedor para mostrar seguridad
                FutureBuilder(
                    future: getSeguridad(),
                    builder: (context,
                        AsyncSnapshot<List<SeguridadModel>> seguridad) {
                      // Indicador de carga mientras se obtienen los datos
                      if (seguridad.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Extraer detalles de seguridad para el sitio actual
                      for (var f = 0; f < seguridad.data!.length; f++) {
                        if (widget.sitio.id == seguridad.data![f].sitio) {
                          seguridadSitio = seguridad.data![f];
                        }
                      }

                      // Contenedor con información de seguridad
                      return InkWell(
                        onTap: () {
                          _modalSeguridad(context, seguridadSitio);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: isDark ? secondaryColor : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, elevacion2),
                                ),
                              ]),
                          child: const Text(
                            "Seguridad y propiedad",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      );
                    }),
                // Contenedor con un enlace a la política de cancelación
                InkWell(
                  onTap: () async {
                    String url =
                        "https://stayawaypagos.000webhostapp.com/terminos.pdf";
                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: isDark ? secondaryColor : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, elevacion3),
                          ),
                        ]),
                    child: const Text(
                      "Política de cancelación",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          // Diseño para móviles
          if (Responsive.isMobile(context))
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Contenedor para mostrar reglas en móviles
                FutureBuilder(
                    future: getRegla(),
                    builder: (context, AsyncSnapshot<List<ReglaModel>> regla) {
                      if (regla.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var x = 0; x < regla.data!.length; x++) {
                        if (widget.sitio.id == regla.data![x].sitio) {
                          reglaSitio = regla.data![x];
                        }
                      }

                      // Contenedor con información de reglas en móviles
                      return InkWell(
                        onTap: () {
                          _modalRegla(context, reglaSitio);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: isDark ? secondaryColor : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, elevacion),
                                ),
                              ]),
                          child: const Text(
                            "Reglas de la casa",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Contenedor para mostrar seguridad en móviles
                FutureBuilder(
                    future: getSeguridad(),
                    builder: (context,
                        AsyncSnapshot<List<SeguridadModel>> seguridad) {
                      if (seguridad.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var f = 0; f < seguridad.data!.length; f++) {
                        if (widget.sitio.id == seguridad.data![f].sitio) {
                          seguridadSitio = seguridad.data![f];
                        }
                      }

                      // Contenedor con información de seguridad en móviles
                      return InkWell(
                        onTap: () {
                          _modalSeguridad(context, seguridadSitio);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: isDark ? secondaryColor : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, elevacion2),
                                ),
                              ]),
                          child: const Text(
                            "Seguridad y propiedad",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Contenedor con un enlace a la política de cancelación en móviles
                InkWell(
                  onTap: () async {
                    String url =
                        "https://stayawaypagos.000webhostapp.com/terminos.pdf";
                    final Uri _url = Uri.parse(url);

                    await launchUrl(_url);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: isDark ? secondaryColor : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, elevacion3),
                          ),
                        ]),
                    child: const Text(
                      "Política de cancelación",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Función para mostrar el modal de reglas
void _modalRegla(BuildContext context, ReglaModel regla) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Título del modal
                Text(
                  "Reglas del sitio",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Cuerpo del modal con texto desplazable
                Expanded(
                  child: SizedBox(
                    height: 495,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Text(
                      regla.descripcion,
                      style: const TextStyle(color: Colors.grey),
                    )),
                  ),
                ),
              ],
            ),
          ),
          // Acciones del modal
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar"))
              ],
            )
          ],
        );
      });
}

// Función para mostrar el modal de seguridad
void _modalSeguridad(BuildContext context, SeguridadModel seguridad) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Título del modal
                Text(
                  "Seguridad y propiedad del sitio",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Cuerpo del modal con texto desplazable
                Expanded(
                  child: SizedBox(
                    height: 495,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        child: Text(
                      seguridad.descripcion,
                      style: const TextStyle(color: Colors.grey),
                    )),
                  ),
                ),
              ],
            ),
          ),
          // Acciones del modal
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar"))
              ],
            )
          ],
        );
      });
}
