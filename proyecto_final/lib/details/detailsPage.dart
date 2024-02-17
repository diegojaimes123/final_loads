// ignore_for_file: file_names

import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chatbotweb/chatBotWeb.dart';
import 'package:proyecto_final/details/components/comentarioDetails.dart';
import 'package:proyecto_final/details/components/iconsMobile.dart';
import 'package:proyecto_final/details/components/imageDetails.dart';
import 'package:proyecto_final/details/components/mapaDetails.dart';
import 'package:proyecto_final/details/components/searchBar.dart';
import 'package:proyecto_final/details/components/titleDetails.dart';
import 'package:proyecto_final/details/screens/InferiorDetails.dart';
import 'package:proyecto_final/details/screens/leftDetails.dart';
import 'package:proyecto_final/details/screens/rightDetails.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';

class DetailsPage extends StatefulWidget {
  // parametros para almacenar el sitio y la lista de usuarios
  final SitioModel sitio;

  final List<UsuariosModel> usuario;

  final ThemeManager themeManager;

  const DetailsPage({
    super.key,
    required this.sitio,
    required this.usuario,
    required this.themeManager,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // Constructor para inicializar Alan Voice si no es una plataforma web
  _DetailsPageState() {
    if (!UniversalPlatform.isWeb) {
      /// Inicializar el botón de Alan con la clave del proyecto desde Alan AI Studio
      /// Init Alan Button with project key from Alan AI Studio
      AlanVoice.addButton(
          "257726fb1e303ccaf96867d4b3de54d42e956eca572e1d8b807a3e2338fdd0dc/stage",
          buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

      /// Manejar comandos desde Alan AI Studio
      /// Handle commands from Alan AI Studio
      AlanVoice.onCommand.add((command) {
        debugPrint("got new command ${command.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                const SizedBox(
                  height: defaultPadding,
                ),
                // Header
                SearchHeader(
                  themeManager: widget.themeManager,
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
                // Titulo
                TitleDetails(
                  sitio: widget.sitio,
                  usuario: widget.usuario,
                  themeManager: widget.themeManager,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Verificar si la pantalla es móvil o tablet
                if (Responsive.isMobile(context) ||
                    Responsive.isTablet(context))
                  // Icono de compartir y favoritos
                  IconsMobile(
                    sitio: widget.sitio,
                    usuario: widget.usuario,
                    themeManager: widget.themeManager,
                  ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Galeria de imagenes
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        ImagesDetails(
                          sitio: widget.sitio,
                        ),
                      ],
                    )),
                // Botón para ver la galeria completa
                ImageButton(
                  sitio: widget.sitio,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // parte izquierda y derecha de la pagina de detalles en escritorio
                SafeArea(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      LeftDetails(
                        sitio: widget.sitio,
                      ),
                      if (Responsive.isDesktop(context))
                        Expanded(
                            flex: 1,
                            child: RightDetails(
                              sitio: widget.sitio,
                              themeManager: widget.themeManager,
                              usuario: usuario,
                            )),
                    ],
                  ),
                ),
                // contenido de la parte derecha en caso que sean dispositivos moviles o tablet
                if (Responsive.isMobile(context) ||
                    Responsive.isTablet(context))
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: RightDetails(
                            sitio: widget.sitio,
                            themeManager: widget.themeManager,
                            usuario: usuario,
                          )),
                    ],
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
                // Zona de comentarios
                ComentarioDetails(
                  sitio: widget.sitio,
                  usuario: usuario,
                  themeManager: widget.themeManager,
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
                // Mapa
                MapaDetails(sitio: widget.sitio),
                const SizedBox(
                  height: defaultPadding,
                ),
                const Divider(
                  height: 1,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                // Zona inferior
                InferiorDetails(
                  sitio: widget.sitio,
                ),
              ],
            ),
          ),
        ),
      ),
      // Botón flotante para plataforma web y Windows
      floatingActionButton: _getFloating(),
    );
  }

  // Método para obtener el botón flotante según la plataforma
  _getFloating() {
    if (UniversalPlatform.isWeb) {
      return FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla del chatbot web
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotWeb()),
          );
        },
        child: const Icon(Icons.support_agent),
      );
    } else if (UniversalPlatform.isWindows) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotWeb()),
          );
        },
        child: const Icon(Icons.support_agent),
      );
    } else {
      return null;
    }
  }
}
