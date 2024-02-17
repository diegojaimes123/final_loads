// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/details/components/habitacionCard.dart';
import 'package:proyecto_final/models/HabitacionModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class HabitacionDetails extends StatefulWidget {
  // parametros para almacenar el sitio 
  final SitioModel sitio;

  const HabitacionDetails({super.key, required this.sitio});

  @override
  State<HabitacionDetails> createState() => _HabitacionDetailsState();
}

class _HabitacionDetailsState extends State<HabitacionDetails> {
  // Lista para almacenar las habitaciones encontradas
  List<HabitacionModel> listaHabitaciones = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titulo de la sección
        Text(
          "¿Dónde vas a dormir?",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
              future: getHabitacion(), // traer las habitaciones del servidor
              builder:
                  (context, AsyncSnapshot<List<HabitacionModel>> habitacion) {
                // Mientras carga la información
                if (habitacion.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Traer las habitaciones relacionadas al sitio
                for (var h = 0; h < habitacion.data!.length; h++) {
                  if (widget.sitio.id == habitacion.data![h].sitio) {
                    listaHabitaciones.add(habitacion.data![h]);
                  }
                }

                return InteractiveViewer(
                  constrained: false,
                  scaleEnabled: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // Carta la cual almacenara cada habitación encontrada
                    child: Row(
                        children: listaHabitaciones.map((habitacion) {
                      return HabitacionCard(habitacion: habitacion);
                    }).toList()),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
