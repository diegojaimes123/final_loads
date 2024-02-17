// ignore_for_file: unnecessary_import, file_names, avoid_print, use_build_context_synchronously, unnecessary_overrides

import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/details/components/confirmacionPago.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

import '../models/ip/local.dart';

// ignore: must_be_immutable
class IdentificacionRClases extends StatefulWidget {
  // Propiedades para almacenar los datos necesarios para hacer la reserva
  final ThemeManager themeManager;
  final SitioModel sitio;
  final String fechaEntrada;
  final String fechaSalida;
  final String totalHuespedes;
  final int valorDias;
  final int valorTotal;
  final int totalNoches;
  final String numeroAdultos;
  final String numeroNinos;
  final String numeroBebes;
  final String numeroMascotas;
  final int usuario;
  const IdentificacionRClases(
      {Key? key,
      required this.themeManager,
      required this.sitio,
      required this.fechaEntrada,
      required this.fechaSalida,
      required this.totalHuespedes,
      required this.valorDias,
      required this.valorTotal,
      required this.totalNoches,
      required this.numeroAdultos,
      required this.numeroNinos,
      required this.numeroBebes,
      required this.numeroMascotas,
      required this.usuario})
      : super(key: key);

  @override
  State<IdentificacionRClases> createState() => _IdentificacionRClasesState();
}

class _IdentificacionRClasesState extends State<IdentificacionRClases>
    with SingleTickerProviderStateMixin {
  _IdentificacionRClasesState();

  // Instancia de la clase SpeechToText para reconocimiento de voz
  SpeechToText speechToText = SpeechToText();

  // Variables para almacenar el texto y controlar el estado del reconocimiento de voz
  var text = "Stay away";
  var valor = "";
  var isListening = false;

  // Método para realizar la autenticación y registrar la reserva
  Future logInR() async {
    // URL del servidor para el registro de reservas
    String url = "";

    // Configurar la URL según la plataforma (Android o no Android)
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Reservas/";
    } else {
      url = "http://127.0.0.1:8000/api/Reservas/";
    }

    // Cabeceras y cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "usuario": widget.usuario,
      "fecha":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "fechaEntrada": widget.fechaEntrada,
      "fechaSalida": widget.fechaSalida,
      "numHuespedes": widget.totalHuespedes,
      "numAdultos": widget.numeroAdultos,
      "numNinos": widget.numeroNinos == "" ? null : widget.numeroNinos,
      "numBebes": widget.numeroBebes == "" ? null : widget.numeroBebes,
      "numMascotas": widget.numeroMascotas == "" ? null : widget.numeroMascotas,
      "precioFinal": widget.valorTotal,
      "estado": "Pendiente",
      "comision": widget.sitio.comision,
      "gananciaAnfitrion": (widget.valorTotal -
          widget.sitio.comision -
          (widget.valorTotal * 0.19).toInt()),
      "sitio": widget.sitio.id,
    };

    int resultado = 0;

    try {
      // Realizar la solicitud HTTP para el registro de la reserva
      final response = await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );

      // Actualizar el resultado según la respuesta del servidor
      setState(() {
        resultado = response.statusCode;
      });
    } catch (e) {
      print(e);
    }

    // Si el registro es exitoso, navegar a la pantalla de confirmación de pago
    if (resultado == 201) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ConfirmacionPago(
            themeManager: widget.themeManager,
            sitioModel: widget.sitio,
            fechaEntrada: widget.fechaEntrada,
            fechaSalida: widget.fechaSalida,
            totalHuespedes: widget.totalHuespedes,
            totalNoches: widget.totalNoches,
            valorDias: widget.valorDias,
            valorTotal: widget.valorTotal,
          ),
        ),
      );
    }
  }

  // Liberar recursos al salir de la pantalla
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, responsive) {
      //Aqui al igual ya es responsive atravez de los condicionales
      // Validar si el ancho de la pantalla es igual a 375
      if (responsive.maxWidth == 375) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    /*
                    Las vistas tanto del registro como del inicio de sesion estan dentro de un expanded
                    porque me daba un error entonce la unica forma de que encontre de que funcionara fue con un exoanded
                    donde le di un tamaño con el flex
                    * */
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Autenticación',
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Diga la siguiente palabra:",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          fontSize: 60, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Center(
                                child: Text(
                                  valor,
                                  style: const TextStyle(
                                      fontSize: 60, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Botón el cual se encarga de hacer el reconocimiento por voz
                            Padding(
                              padding: const EdgeInsets.only(left: 65),
                              child: Center(
                                child: AvatarGlow(
                                  animate: isListening,
                                  duration: const Duration(milliseconds: 2000),
                                  glowColor: Colors.white,
                                  repeat: true,
                                  repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                  showTwoGlows: true,
                                  endRadius: 75.0,
                                  child: GestureDetector(
                                    // Configurar un gesto de toque hacia abajo (onTapDown)
                                    onTapDown: (details) async {
                                      // Verificar si el reconocimiento de voz no está en curso
                                      if (!isListening) {
                                        // Inicializar el reconocimiento de voz
                                        var available =
                                            await speechToText.initialize();
                                        // Verificar si el reconocimiento de voz está disponible en el dispositivo
                                        if (available) {
                                          // Iniciar el reconocimiento de voz y escuchar los resultados
                                          isListening = true;
                                          speechToText.listen(
                                              onResult: (result) {
                                            // Actualizar el estado con las palabras reconocidas
                                            setState(() {
                                              valor = result.recognizedWords;
                                            });
                                          });
                                        }
                                      }
                                    },
                                    // Configurar un gesto de toque hacia arriba (onTapUp)
                                    onTapUp: (details) {
                                      // Actualizar el estado para indicar que el reconocimiento de voz se detuvo
                                      setState(() {
                                        isListening = false;
                                      });
                                      // Detener el reconocimiento de voz
                                      speechToText.stop();
                                      // Verificar si el texto reconocido coincide con el texto esperado
                                      if (text == valor) {
                                        // Realizar la acción correspondiente (en este caso, llamar al método logInR())
                                        logInR();
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 35,
                                      child: Icon(
                                        isListening
                                            ? Icons.mic
                                            : Icons.mic_none,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
        // Validar si el ancho de la pantalla es igual o menor a 300
      } else if (responsive.maxWidth <= 300) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
            child: Container(
                decoration: BoxDecoration(
                  color: //Colors.black,
                      const Color(0x20D2D2D2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Autenticación',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Diga la siguiente palabra:",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          fontSize: 60, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Center(
                                  child: Text(
                                    valor,
                                    style: const TextStyle(
                                        fontSize: 60, color: Colors.white),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            // Botón el cual se encarga de realizar el reconocimiento de voz
                            Padding(
                              padding: const EdgeInsets.only(left: 60),
                              child: Center(
                                child: AvatarGlow(
                                  animate: isListening,
                                  duration: const Duration(milliseconds: 2000),
                                  glowColor: Colors.white,
                                  repeat: true,
                                  repeatPauseDuration:
                                      const Duration(milliseconds: 100),
                                  showTwoGlows: true,
                                  endRadius: 75.0,
                                  child: GestureDetector(
                                    // Configurar un gesto de toque hacia abajo (onTapDown)
                                    onTapDown: (details) async {
                                      // Verificar si el reconocimiento de voz no está en curso
                                      if (!isListening) {
                                        // Inicializar el reconocimiento de voz
                                        var available =
                                            await speechToText.initialize();
                                        // Verificar si el reconocimiento de voz está disponible en el dispositivo
                                        if (available) {
                                          // Iniciar el reconocimiento de voz y escuchar los resultados
                                          isListening = true;
                                          speechToText.listen(
                                              onResult: (result) {
                                            // Actualizar el estado con las palabras reconocidas
                                            setState(() {
                                              valor = result.recognizedWords;
                                            });
                                          });
                                        }
                                      }
                                    },
                                    // Configurar un gesto de toque hacia arriba (onTapUp)
                                    onTapUp: (details) {
                                      // Actualizar el estado para indicar que el reconocimiento de voz se detuvo
                                      setState(() {
                                        isListening = false;
                                      });
                                      // Detener el reconocimiento de voz
                                      speechToText.stop();
                                      // Verificar si el texto reconocido coincide con el texto esperado
                                      if (text == valor) {
                                        // Realizar la acción correspondiente (en este caso, llamar al método logInR())
                                        logInR();
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 35,
                                      child: Icon(
                                        isListening
                                            ? Icons.mic
                                            : Icons.mic_none,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
        // Validar si el ancho de la pantalla es igual o menor a 500
      } else if (responsive.maxWidth <= 500) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Autenticación',
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Diga la siguiente palabra:",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          fontSize: 60, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Center(
                                  child: Text(
                                    valor,
                                    style: const TextStyle(
                                        fontSize: 60, color: Colors.white),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            // Botón el cual se encarga de realizar el reconocimiento de voz
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: AvatarGlow(
                                    animate: isListening,
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    glowColor: Colors.white,
                                    repeat: true,
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 100),
                                    showTwoGlows: true,
                                    endRadius: 75.0,
                                    child: GestureDetector(
                                      // Configurar un gesto de toque hacia abajo (onTapDown)
                                      onTapDown: (details) async {
                                        // Verificar si el reconocimiento de voz no está en curso
                                        if (!isListening) {
                                          // Inicializar el reconocimiento de voz
                                          var available =
                                              await speechToText.initialize();
                                          // Verificar si el reconocimiento de voz está disponible en el dispositivo
                                          if (available) {
                                            // Iniciar el reconocimiento de voz y escuchar los resultados
                                            isListening = true;
                                            speechToText.listen(
                                                onResult: (result) {
                                              // Actualizar el estado con las palabras reconocidas
                                              setState(() {
                                                valor = result.recognizedWords;
                                              });
                                            });
                                          }
                                        }
                                      },
                                      // Configurar un gesto de toque hacia arriba (onTapUp)
                                      onTapUp: (details) {
                                        // Actualizar el estado para indicar que el reconocimiento de voz se detuvo
                                        setState(() {
                                          isListening = false;
                                        });
                                        // Detener el reconocimiento de voz
                                        speechToText.stop();
                                        // Verificar si el texto reconocido coincide con el texto esperado
                                        if (text == valor) {
                                          // Realizar la acción correspondiente (en este caso, llamar al método logInR())
                                          logInR();
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 35,
                                        child: Icon(
                                          isListening
                                              ? Icons.mic
                                              : Icons.mic_none,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
        // Validar si el ancho de la pantalla es igual o mayor a 1000
      } else if (responsive.maxWidth >= 1000) {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 30.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'StayAway',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 100,
                              fontFamily: 'CroissantOne'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Text(
                            "Descubre destinos inexplorados, "
                            "vive experiencias únicas y crea recuerdos que "
                            "durarán toda la vida. ¡Únete a la comunidad viajera "
                            "y haz realidad tus sueños de viaje!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'CroissantOne'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0x20D2D2D2),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 6,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 50),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 25),
                                          child: Text(
                                            'Autenticación',
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontFamily: 'DelaGothicOne',
                                                color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25, right: 30),
                                          child: Text(
                                            'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white
                                                //fontFamily: 'DelaGothicOne'
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25.0),
                                      child: Column(
                                        children: [
                                          const Center(
                                            child: Text(
                                              "Diga la siguiente palabra:",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: defaultPadding,
                                          ),
                                          Center(
                                            child: Text(
                                              text,
                                              style: const TextStyle(
                                                  fontSize: 60,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0),
                                        child: Center(
                                          child: Text(
                                            valor,
                                            style: const TextStyle(
                                                fontSize: 60,
                                                color: Colors.white),
                                          ),
                                        )),
                                    const SizedBox(height: 10),
                                    // Botón el cual se encarga de realizar el reconocimiento de voz
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: Center(
                                        child: AvatarGlow(
                                          animate: isListening,
                                          duration: const Duration(
                                              milliseconds: 2000),
                                          glowColor: Colors.white,
                                          repeat: true,
                                          repeatPauseDuration:
                                              const Duration(milliseconds: 100),
                                          showTwoGlows: true,
                                          endRadius: 75.0,
                                          child: GestureDetector(
                                            // Configurar un gesto de toque hacia abajo (onTapDown)
                                            onTapDown: (details) async {
                                              // Verificar si el reconocimiento de voz no está en curso
                                              if (!isListening) {
                                                // Inicializar el reconocimiento de voz
                                                var available =
                                                    await speechToText
                                                        .initialize();
                                                // Verificar si el reconocimiento de voz está disponible en el dispositivo
                                                if (available) {
                                                  // Iniciar el reconocimiento de voz y escuchar los resultados
                                                  isListening = true;
                                                  speechToText.listen(
                                                      onResult: (result) {
                                                    // Actualizar el estado con las palabras reconocidas
                                                    setState(() {
                                                      valor = result
                                                          .recognizedWords;
                                                    });
                                                  });
                                                }
                                              }
                                            },
                                            // Configurar un gesto de toque hacia arriba (onTapUp)
                                            onTapUp: (details) {
                                              // Actualizar el estado para indicar que el reconocimiento de voz se detuvo
                                              setState(() {
                                                isListening = false;
                                              });
                                              // Detener el reconocimiento de voz
                                              speechToText.stop();
                                              // Verificar si el texto reconocido coincide con el texto esperado
                                              if (text == valor) {
                                                // Realizar la acción correspondiente (en este caso, llamar al método logInR())
                                                logInR();
                                              }
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 35,
                                              child: Icon(
                                                isListening
                                                    ? Icons.mic
                                                    : Icons.mic_none,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )))
              ],
            ));
        // Vista por defecto
      } else {
        return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 23.0, vertical: 27.0),
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0x20D2D2D2),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    'Autenticación',
                                    style: TextStyle(
                                        fontSize: 33,
                                        fontFamily: 'DelaGothicOne',
                                        color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, right: 30),
                                  child: Text(
                                    'Viaja con Estilo, Destinos de Ensueño a Tu Alcance',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white
                                        //fontFamily: 'DelaGothicOne'
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  const Center(
                                    child: Text(
                                      "Diga la siguiente palabra:",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                  Center(
                                    child: Text(
                                      text,
                                      style: const TextStyle(
                                          fontSize: 60, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Center(
                                  child: Text(
                                    valor,
                                    style: const TextStyle(
                                        fontSize: 60, color: Colors.black),
                                  ),
                                )),
                            const SizedBox(height: 10),
                            // Botón el cual se encarga de realizar el reconocimiento de voz
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: AvatarGlow(
                                    animate: isListening,
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    glowColor: Colors.white,
                                    repeat: true,
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 100),
                                    showTwoGlows: true,
                                    endRadius: 75.0,
                                    child: GestureDetector(
                                      // Configurar un gesto de toque hacia abajo (onTapDown)
                                      onTapDown: (details) async {
                                        // Verificar si el reconocimiento de voz no está en curso
                                        if (!isListening) {
                                          // Inicializar el reconocimiento de voz
                                          var available =
                                              await speechToText.initialize();
                                          // Verificar si el reconocimiento de voz está disponible en el dispositivo
                                          if (available) {
                                            // Iniciar el reconocimiento de voz y escuchar los resultados
                                            isListening = true;
                                            speechToText.listen(
                                                onResult: (result) {
                                              // Actualizar el estado con las palabras reconocidas
                                              setState(() {
                                                valor = result.recognizedWords;
                                              });
                                            });
                                          }
                                        }
                                      },
                                      // Configurar un gesto de toque hacia arriba (onTapUp)
                                      onTapUp: (details) {
                                        // Actualizar el estado para indicar que el reconocimiento de voz se detuvo
                                        setState(() {
                                          isListening = false;
                                        });
                                        // Detener el reconocimiento de voz
                                        speechToText.stop();
                                        // Verificar si el texto reconocido coincide con el texto esperado
                                        if (text == valor) {
                                          // Realizar la acción correspondiente (en este caso, llamar al método logInR())
                                          logInR();
                                        }
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 35,
                                        child: Icon(
                                          isListening
                                              ? Icons.mic
                                              : Icons.mic_none,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
      }
    });
  }
}
