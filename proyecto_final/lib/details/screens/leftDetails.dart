// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/details/components/ServiciosDetails.dart';
import 'package:proyecto_final/details/components/anfitrionDetails.dart';
import 'package:proyecto_final/details/components/calendarioDetails.dart';
import 'package:proyecto_final/details/components/descripcionDetails.dart';
import 'package:proyecto_final/details/components/habitacionDetails.dart';
import 'package:proyecto_final/models/HabitacionModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class LeftDetails extends StatelessWidget {
  // parametros para poder realizar y llamar funciones en la vista de detalles
  final SitioModel sitio;

  const LeftDetails({
    super.key,
    required this.sitio,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Detalles del anfitrión
                AnfitrionDetails(
                  sitio: sitio,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Información sobre cancelación
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: primaryColor,
                          ),
                          const SizedBox(
                            width: defaultPadding,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cancelación gratuita por 48 horas",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Descripción del sitio
                DescripcionDetails(
                  sitio: sitio,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Detalles de habitación si existen
                FutureBuilder(
                    future: getHabitacion(),
                    builder: (context,
                        AsyncSnapshot<List<HabitacionModel>> habitacion) {
                      if (habitacion.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var h = 0; h < habitacion.data!.length; h++) {
                        if (sitio.id == habitacion.data![h].sitio) {
                          return HabitacionDetails(
                            sitio: sitio,
                          );
                        }
                      }

                      return Container();
                    }),
                // Espaciado si hay habitaciones
                FutureBuilder(
                    future: getHabitacion(),
                    builder: (context,
                        AsyncSnapshot<List<HabitacionModel>> habitacion) {
                      if (habitacion.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var h = 0; h < habitacion.data!.length; h++) {
                        if (sitio.id == habitacion.data![h].sitio) {
                          return const SizedBox(
                            height: defaultPadding,
                          );
                        }
                      }

                      return Container();
                    }),
                // Divider si hay habitaciones
                FutureBuilder(
                    future: getHabitacion(),
                    builder: (context,
                        AsyncSnapshot<List<HabitacionModel>> habitacion) {
                      if (habitacion.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var h = 0; h < habitacion.data!.length; h++) {
                        if (sitio.id == habitacion.data![h].sitio) {
                          return const Divider(
                            height: 1,
                          );
                        }
                      }

                      return Container();
                    }),
                // Espaciado si no hay habitaciones
                FutureBuilder(
                    future: getHabitacion(),
                    builder: (context,
                        AsyncSnapshot<List<HabitacionModel>> habitacion) {
                      if (habitacion.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      for (var h = 0; h < habitacion.data!.length; h++) {
                        if (sitio.id == habitacion.data![h].sitio) {
                          return const SizedBox(
                            height: defaultPadding,
                          );
                        }
                      }

                      return Container();
                    }),
                // Sección de servicios
                ServiciosSection(
                  sitio: sitio,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Calendario de disponibilidad
                CalendarioDetails(
                  sitio: sitio,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
              ],
            ),
          ),
        ));
  }
}
