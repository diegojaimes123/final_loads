// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class DescripcionDetails extends StatefulWidget {
  // parametros para almacenar el sitio
  final SitioModel sitio;

  const DescripcionDetails({
    super.key,
    required this.sitio,
  });

  @override
  State<DescripcionDetails> createState() => _DescripcionDetailsState();
}

class _DescripcionDetailsState extends State<DescripcionDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Fragmento del la descripción del sitio
        Text(
          widget.sitio.descripcion,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        // Botón para mostrar la descripción del sitio completa
        TextButton(
            onPressed: () {
              _modalDescripcion(context, widget.sitio);
            },
            child: Text(
              "Mostar Más >",
              style: Theme.of(context).textTheme.titleMedium,
            ))
      ],
    );
  }
}

// Modal de la descripción completa
void _modalDescripcion(BuildContext context, SitioModel sitio) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 600,
            width: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Titulo del modal
                Text(
                  "Acerca de este espacio",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Descripción del sitio
                Expanded(
                    child: Text(
                  sitio.descripcion,
                  style: const TextStyle(color: Colors.grey),
                )),
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
