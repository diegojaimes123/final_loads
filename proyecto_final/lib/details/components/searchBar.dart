// ignore_for_file: file_names, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:proyecto_final/HomePage/home_screens.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';

// Encabezado detalles
class SearchHeader extends StatelessWidget {
  final ThemeManager themeManager;

  const SearchHeader({
    super.key,
    required this.themeManager,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo de la aplicación
                const Image(
                  image: AssetImage('assets/images/logo.png'),
                  width: 100,
                  height: 70,
                ),
                // Carta la cual navega a la pagina principal
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreenPage(
                                  themeManager: themeManager,
                                )),
                      );
                    },
                    child: const ProfileCardDetails()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCardDetails extends StatelessWidget {
  const ProfileCardDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verificar el tema del aplicativo
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 38,
              height: 38,
              color: primaryColor,
              child: const Icon(
                Icons.home_outlined,
                color: Colors.white,
              ),
            ),
          ),
          // Validación del ancho de la pantalla
          if (Responsive.isDesktop(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Home"),
            ),
        ],
      ),
    );
  }
}
