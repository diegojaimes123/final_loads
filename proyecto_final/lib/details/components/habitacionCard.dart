// ignore_for_file: file_names

import "package:flutter/material.dart";
import "package:proyecto_final/models/HabitacionModel.dart";
import "package:proyecto_final/theme/theme_constants.dart";

class HabitacionCard extends StatelessWidget {
  // parametro para almacenar la habitación
  final HabitacionModel habitacion;

  const HabitacionCard({super.key, required this.habitacion});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Container(
                            color: primaryColor,
                            child: const Icon(
                              Icons.bed_outlined,
                              size: 40,
                              color: Colors.white,
                            ),
                          )),
                      const SizedBox(
                        width: defaultPadding,
                      ),
                      // Titulo de la habitación
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habitacion.titulo,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // descripción de la habitación
                Text(
                  habitacion.descripcion,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
