import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/LoginUsuario/Login/LoginAndRegister.dart';
import 'package:proyecto_final/details/detailsPage.dart';
import 'package:proyecto_final/models/ComentarioModel.dart';
import 'package:proyecto_final/models/FavoritoModel.dart';
import 'package:proyecto_final/models/ImagenModel.dart';
import 'package:proyecto_final/models/SitioModel.dart';
import 'package:proyecto_final/models/SitioVisitadoModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/models/ip/local.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:http/http.dart' as http;

// Esta es la carta principal la cual sera una previsualización de los sitios ofertados
class CardSite extends StatefulWidget {
  final SitioModel sitio;
  final List<UsuariosModel> usuario;
  final ThemeManager themeManager;
  const CardSite({
    super.key,
    required this.sitio,
    required this.usuario,
    required this.themeManager,
  });

  @override
  State<CardSite> createState() => _CardSiteState();
}

class _CardSiteState extends State<CardSite> {
  // estado inicial del botón de favoritos
  late bool isFavorite = false;

  PageController? controller;
  int currentIndex = 0;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  // Método para registrar un sitio como favorito
  registerFavorito(int sitio, int usuario) async {
    String url = "";

    // Verifica la plataforma y configura la URL correspondiente
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Favoritos/";
    } else {
      url = "http://127.0.0.1:8000/api/Favoritos/";
    }

    // Configura los encabezados y el cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "usuario": usuario,
      "sitio": sitio,
    };

    try {
      // Realiza la solicitud POST para registrar el favorito
      await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // Método para eliminar un favorito
  deleteFavorito(int id) async {
    String url = "";

    // Verifica la plataforma y configura la URL correspondiente
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/Favoritos/";
    } else {
      url = "http://127.0.0.1:8000/api/Favoritos/";
    }

    // Realiza la solicitud DELETE para eliminar el favorito
    await http.delete(Uri.parse("$url$id/"));
  }

  // Método para registrar un sitio como visitado
  registerSitioVisitado(int sitio, int usuario) async {
    String url = "";

    // Verifica la plataforma y configura la URL correspondiente
    if (UniversalPlatform.isAndroid) {
      url = "http://$ip_ideapat:8000/api/SitioVisitado/";
    } else {
      url = "http://127.0.0.1:8000/api/SitioVisitado/";
    }

    // Configura los encabezados y el cuerpo de la solicitud HTTP
    final Map<String, String> dataHeader = {
      'Content-Type': 'application/json; charset-UTF=8',
    };

    final Map<String, dynamic> dataBody = {
      "fechaVista":
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
      "sitio": sitio,
      "usuario": usuario,
    };

    try {
      // Realiza la solicitud POST para registrar la visita al sitio
      await http.post(
        Uri.parse(url),
        headers: dataHeader,
        body: json.encode(dataBody),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica si el tema actual es oscuro
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Lista para almacenar las direcciones de las imágenes
    List<String> listaImagen = [];

    // Objeto para almacenar información sobre favoritos
    late FavoritoModel favoritos;

    return FutureBuilder(
        // Obtiene la lista de sitios visitados
        future: getSitioVisitado(),
        builder:
            (context, AsyncSnapshot<List<SitioVisitadoModel>> sitioVisitado) {
          if (sitioVisitado.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return FutureBuilder(
              // Obtiene la lista de sitios favoritos
              future: getFavorito(),
              builder: (context, AsyncSnapshot<List<FavoritoModel>> favorito) {
                if (favorito.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Verifica si el usuario actual está autenticado
                if (FirebaseAuth.instance.currentUser == null) {
                  // Si no está autenticado, establece el valor de isFavorite en false
                  isFavorite = false;
                } else {
                  // Si está autenticado, verifica si el sitio actual es un favorito del usuario actual
                  for (var uf = 0; uf < widget.usuario.length; uf++) {
                    for (var f = 0; f < favorito.data!.length; f++) {
                      if (FirebaseAuth.instance.currentUser!.email ==
                          widget.usuario[uf].correoElectronico) {
                        if ((favorito.data![f].sitio == widget.sitio.id) &&
                            (favorito.data![f].usuario ==
                                widget.usuario[uf].id)) {
                          favoritos = favorito.data![f];
                          isFavorite = true;
                        }
                      }
                    }
                  }
                }

                return FutureBuilder(
                    // Obtiene la lista de comentarios
                    future: getComentarios(),
                    builder: (context,
                        AsyncSnapshot<List<ComentarioModel>> comentario) {
                      if (comentario.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Variables para calcular promedio de calificaciones
                      int totalComentarios = 0;
                      double totalLimpieza = 0.0;
                      double totalComunicacion = 0.0;
                      double totalLlegada = 0.0;
                      double totalFiabilidad = 0.0;
                      double totalUbicacion = 0.0;
                      double totalPrecio = 0.0;

                      // Calcula sumas de calificaciones
                      for (var z = 0; z < comentario.data!.length; z++) {
                        if (widget.sitio.id == comentario.data![z].sitio.id) {
                          totalComentarios++;
                          totalLimpieza += comentario.data![z].calLimpieza;
                          totalComunicacion +=
                              comentario.data![z].calComunicacion;
                          totalLlegada += comentario.data![z].calLlegada;
                          totalFiabilidad += comentario.data![z].calFiabilidad;
                          totalUbicacion += comentario.data![z].calUbicacion;
                          totalPrecio += comentario.data![z].calPrecio;
                        }
                      }

                      // Calcula promedios
                      double avgLimpieza = totalLimpieza / totalComentarios;
                      double avgComunicacion =
                          totalComunicacion / totalComentarios;
                      double avgLlegada = totalLlegada / totalComentarios;
                      double avgFiabilidad = totalFiabilidad / totalComentarios;
                      double avgUbicacion = totalUbicacion / totalComentarios;
                      double avgPrecio = totalPrecio / totalComentarios;

                      // Calcula promedio total
                      double avgTotal = (avgLimpieza +
                              avgComunicacion +
                              avgLlegada +
                              avgFiabilidad +
                              avgUbicacion +
                              avgPrecio) /
                          6;

                      return FutureBuilder(
                          // Obtiene la lista de imágenes del sitio
                          future: getImagen(),
                          builder: (context,
                              AsyncSnapshot<List<ImagenModel>> imagen) {
                            if (imagen.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            // Almacena las direcciones de las imágenes
                            for (var h = 0; h < imagen.data!.length; h++) {
                              if (widget.sitio.id == imagen.data![h].sitio) {
                                listaImagen.add(imagen.data![h].direccion);
                              }
                            }

                            return InkWell(
                              // Registra la visita al sitio si el usuario está autenticado y aún no ha visitado el sitio
                              onTap: () {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  for (var u = 0;
                                      u < widget.usuario.length;
                                      u++) {
                                    if (FirebaseAuth
                                            .instance.currentUser!.email ==
                                        widget.usuario[u].correoElectronico) {
                                      if (sitioVisitado.data == null ||
                                          sitioVisitado.data!.isEmpty) {
                                        // Si sitioVisitado.data es nulo o está vacío, registra la visita una sola vez
                                        registerSitioVisitado(widget.sitio.id,
                                            widget.usuario[u].id);
                                      } else {
                                        // Si sitioVisitado.data tiene elementos, verifica si el usuario ya ha visitado el sitio
                                        bool usuarioHaVisitadoSitio =
                                            sitioVisitado.data!.any((registro) {
                                          return (registro.sitio ==
                                                  widget.sitio.id) &&
                                              (registro.usuario ==
                                                  widget.usuario[u].id);
                                        });

                                        // Si el usuario no ha visitado el sitio, registra la visita
                                        if (!usuarioHaVisitadoSitio) {
                                          registerSitioVisitado(widget.sitio.id,
                                              widget.usuario[u].id);
                                        }
                                      }
                                    }
                                  }
                                }

                                // Navega a la página de detalles del sitio
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => DetailsPage(
                                              sitio: widget.sitio,
                                              usuario: usuario,
                                              themeManager: widget.themeManager,
                                            )));
                              },
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? secondaryColor
                                      // ignore: use_full_hex_values_for_flutter_colors
                                      : const Color(0xFFFF2F0F2),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Stack(
                                        children: [
                                          // Contenedor de las imágenes del sitio
                                          PageView.builder(
                                              controller: controller,
                                              itemCount: 3,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                              listaImagen[
                                                                  index],
                                                            ),
                                                            fit: BoxFit.cover),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Stack(
                                                            children: [
                                                              // Botón de favorito
                                                              Positioned(
                                                                top: 10,
                                                                right: 5,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .black38,
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        isFavorite
                                                                            ? Icons.favorite
                                                                            : Icons.favorite_border,
                                                                        color: isFavorite
                                                                            ? primaryColor
                                                                            : Colors.white,
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        // Maneja el evento de hacer clic en el botón de favorito
                                                                        if (FirebaseAuth.instance.currentUser !=
                                                                            null) {
                                                                          if (isFavorite ==
                                                                              true) {
                                                                            // Elimina el sitio de favoritos
                                                                            deleteFavorito(favoritos.id);
                                                                            setState(() {
                                                                              isFavorite = false;
                                                                            });
                                                                          } else if (isFavorite ==
                                                                              false) {
                                                                            // Registra el sitio como favorito
                                                                            for (var us = 0;
                                                                                us < widget.usuario.length;
                                                                                us++) {
                                                                              if (FirebaseAuth.instance.currentUser!.email == widget.usuario[us].correoElectronico) {
                                                                                registerFavorito(widget.sitio.id, widget.usuario[us].id);
                                                                                setState(() {
                                                                                  isFavorite = true;
                                                                                });
                                                                              }
                                                                            }
                                                                          }
                                                                        } else {
                                                                          // Muestra un modal para iniciar sesión si el usuario no está autenticado
                                                                          _modalIniciarSesion(
                                                                              context,
                                                                              widget.themeManager);
                                                                        }
                                                                      },
                                                                      iconSize:
                                                                          25.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Calificación promedio
                                                              Positioned(
                                                                top: 10,
                                                                left: 5,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    color: Colors
                                                                        .black38,
                                                                    child: Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              17,
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                4),
                                                                        Text(
                                                                          "${avgTotal.isNaN ? 0.0 : avgTotal.toStringAsFixed(1)}",
                                                                          style: const TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Indicadores de las imágenes
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children:
                                                                          List.generate(
                                                                        3,
                                                                        (index) =>
                                                                            buildDot(
                                                                          index,
                                                                          context,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ));
                                              }),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Información del sitio
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        widget.sitio.lugar,
                                                        style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 2),
                                              child: Text(
                                                widget.sitio.titulo,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, left: 10),
                                              child: Text(
                                                "Categoría: ${widget.sitio.categoria.nombre}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2, left: 10),
                                              child: Text(
                                                "Huespedes: ${widget.sitio.numHuespedes}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 2, left: 10),
                                              child: Text(
                                                " \$  ${widget.sitio.valorNocheFormatted} Noche",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    });
              });
        });
  }

  AnimatedContainer buildDot(int index, BuildContext context) {
    // Devuelve un contenedor animado para representar el indicador de la imagen actual
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 8,
      width: currentIndex == index ? 14 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index ? Colors.white : Colors.grey),
    );
  }

  void _modalIniciarSesion(BuildContext context, ThemeManager themeManager) {
    // Muestra un cuadro de diálogo para indicar que es necesario iniciar sesión
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "¿Quiere realizar esta acción?",
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 250,
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    const Center(
                      child: Text(
                        "Para llevar a cabo esta acción, es necesario iniciar sesión primero.",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                      height: 150,
                    )
                  ],
                ),
              ),
            ),
            actions: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar")),
                  ElevatedButton(
                      onPressed: () async {
                        // Navega a la página de inicio de sesión
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginPage(themeManager: themeManager),
                          ),
                        );
                      },
                      child: const Text("Iniciar Sesión")),
                ],
              ),
            ],
          );
        });
  }
}
