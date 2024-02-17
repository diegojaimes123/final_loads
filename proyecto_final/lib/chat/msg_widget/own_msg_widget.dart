import 'package:flutter/material.dart';
import 'package:proyecto_final/theme/theme_constants.dart';

class OnwMsgWidget extends StatelessWidget {
  final String
      sender; // Nombre del remitente del mensaje (en este caso, el usuario actual)
  final String msg; // Contenido del mensaje
  const OnwMsgWidget({super.key, required this.sender, required this.msg});

  @override
  Widget build(BuildContext context) {
    // El widget Align se utiliza para alinear el contenido a la derecha del contenedor
    return Align(
      alignment: Alignment.bottomRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
          color: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Muestra el nombre del remitente (usuario actual) en negrita y blanco
                Text(
                  sender,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 3,
                ),
                // Muestra el contenido del mensaje en blanco
                Text(
                  msg,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
