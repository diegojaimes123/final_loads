// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:proyecto_final/details/components/reservationCard.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

class RightDetails extends StatelessWidget {
  // parametros para poder realizar y llamar funciones en la vista de detalles
  final SitioModel sitio;

  final ThemeManager themeManager;

  final List<UsuariosModel> usuario;

  const RightDetails({
    Key? key,
    required this.sitio,
    required this.themeManager,
    required this.usuario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Zona de reservaciones
          ReservationCard(
            sitio: sitio,
            themeManager: themeManager,
            usuario: usuario,
          ),
        ],
      ),
    );
  }
}
