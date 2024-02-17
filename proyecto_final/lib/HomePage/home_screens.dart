import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/chatbotweb/chatBotWeb.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'explore/explore_screen.dart';

class HomeScreenPage extends StatefulWidget {
  final ThemeManager themeManager;

  const HomeScreenPage({super.key, required this.themeManager});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage>
    with SingleTickerProviderStateMixin {
  // Constructor de la clase
  _HomeScreenPageState() {
    // Inicialización de Alan Button solo si la plataforma no es web
    if (!UniversalPlatform.isWeb) {
      /// Init Alan Button with project key from Alan AI Studio
      AlanVoice.addButton(
          "257726fb1e303ccaf96867d4b3de54d42e956eca572e1d8b807a3e2338fdd0dc/stage",
          buttonAlign: AlanVoice.BUTTON_ALIGN_RIGHT);

      /// Handle commands from Alan AI Studio
      /// Manejo de comandos desde Alan AI Studio
      AlanVoice.onCommand.add((command) {
        debugPrint("got new command ${command.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // contenido del home page
        body: ExploreScreen(
          themeManager: widget.themeManager,
        ),
        // botón flotante para el chatbot escrito en caso que se este usando el aplicativo en entorno web
        floatingActionButton: _getFloating(),
      ),
    );
  }

  // Método privado que devuelve el botón flotante según la plataforma
  _getFloating() {
    if (UniversalPlatform.isWeb) {
      return FloatingActionButton(
        onPressed: () {
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
      return null; // Retorna null si la plataforma no es web ni Windows
    }
  }
}
