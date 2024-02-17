// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/models/ServicioModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class ServiciosDetails extends StatelessWidget {
  // parametros para almacenar el sitio 
  final SitioModel sitio;

  const ServiciosDetails({
    super.key,
    required this.sitio,
  });

  @override
  Widget build(BuildContext context) {
    // Verificar si el tema actual es oscuro
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Listas para almacenar servicios según la ubicación
    List<ServicioModel> listaServicio = [];

    List<ServicioModel> listaServicio2 = [];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: FutureBuilder(
                      future:
                          getServicio(), // llama todos los servicios almacenados
                      builder: (context,
                          AsyncSnapshot<List<ServicioModel>> servicio) {
                        // Mientras carga la información
                        if (servicio.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // guarda en una lista todos los servicios correspondientes al sitio en cuestión
                        for (var s = 0; s < servicio.data!.length; s++) {
                          if (sitio.id == servicio.data![s].sitio) {
                            listaServicio.add(servicio.data![s]);
                          }
                        }

                        // ListView de presentación de los servicios
                        return ListView.builder(
                            itemCount: 6,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            listaServicio[index].icono),
                                        width: 50,
                                        height: 50,
                                      ),
                                      const SizedBox(
                                        width: defaultPadding,
                                      ),
                                      Text(
                                        listaServicio[index].nombre,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                ],
                              );
                            });
                      }),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                FutureBuilder(
                    future:
                        getServicio(), // llama a todos los servicios guardados en el servidor
                    builder:
                        (context, AsyncSnapshot<List<ServicioModel>> servicio) {
                      // Mientras se carga la información
                      if (servicio.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // almacena todos los servicios relacionados al sitio en cuestión
                      for (var s = 0; s < servicio.data!.length; s++) {
                        if (sitio.id == servicio.data![s].sitio) {
                          listaServicio2.add(servicio.data![s]);
                        }
                      }
                      return ElevatedButton(
                        onPressed: () {
                          // modal para ver todos los servicios relacionados al sitio
                          _modalServicio(context, listaServicio2);
                        },
                        style: ButtonStyle(
                          backgroundColor: isDark
                              ? const MaterialStatePropertyAll(secondaryColor)
                              : const MaterialStatePropertyAll(Colors.white),
                          foregroundColor:
                              const MaterialStatePropertyAll(primaryColor),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.all(20.0)),
                        ),
                        child: Text(
                            "Mostrar los ${listaServicio2.length} servicios"),
                      );
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Modal para ver todos los servicios referente a un sitio
void _modalServicio(BuildContext context, List<ServicioModel> servicio) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 600,
            width: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Titulo
                Text(
                  "Lo que este lugar ofrece",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Lista de los servicios referentes a un sitio
                Expanded(
                  child: SizedBox(
                    height: 495,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: servicio.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              ListTile(
                                leading: Image(
                                  image: AssetImage(servicio[index].icono),
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  servicio[index].nombre,
                                  style: const TextStyle(color: primaryColor),
                                ),
                                subtitle: servicio[index]
                                            .descripcion
                                            .isNotEmpty ==
                                        true
                                    ? Text(servicio[index].descripcion,
                                        style:
                                            const TextStyle(color: Colors.grey))
                                    : Container(),
                              ),
                              const Divider(
                                height: 1,
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // acciones del modal
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

// Sección de servicio en la pagina de detalles
class ServiciosSection extends StatelessWidget {
  // parametros para almacenar el sitio 
  final SitioModel sitio;

  const ServiciosSection({
    super.key,
    required this.sitio,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 60.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Titulo
              Text(
                "Lo que este lugar ofrece",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
              // Sección donde se encuentra toda la funcionalidad para ver los servicios
              ServiciosDetails(
                sitio: sitio,
              ),
              const SizedBox(
                height: defaultPadding,
              ),
            ]),
      ),
    );
  }
}
