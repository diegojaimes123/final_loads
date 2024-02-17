import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/cards.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/misPagosRecibidos.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/misSitios.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/reserva_activa_anf.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/reserva_cancelada_anf.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_anfitrion/reserva_finalizada_anf.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/Sitios.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/listaUsuarios_todo.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/reserva_activa_todo.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/reserva_cancelada_todo.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/reserva_finalizada_todo.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/reserva_pendiente_todo.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/totalDevolucionesUsuario.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/totalMultas.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/totalPagosAnfitrion.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_todo/totalPagosUsuario.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/misDevoluciones.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/misMultas.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/misPagos.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/reserva_cancelada_usu.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/reserva_finalizada_usu.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/reserva_usuario/reserva_pendiente_usu.dart';
import 'package:proyecto_final/dashboard/screens/dashboard/components/visitado_details.dart';
import 'package:proyecto_final/models/ReservaModel.dart';
import 'package:proyecto_final/models/SitioVisitadoModel.dart';
import 'package:proyecto_final/models/UsuariosModel.dart';
import 'package:proyecto_final/responsive.dart';
import 'package:proyecto_final/theme/theme_constants.dart';
import 'package:proyecto_final/theme/theme_manager.dart';
import 'components/header.dart';

import 'components/reserva_usuario/reserva_activa_usu.dart';
import 'components/favorito_details.dart';

// Vista donde se llaman todos los componentes del dashboard y tambien direcciona estos componentes para que
// tengan diferentes comportamientos al momento de adaptarlos a diferentes dispositivos

class DashboardScreen extends StatelessWidget {
  final ThemeManager themeManager;

  const DashboardScreen({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // Encabezado
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      // este future builder se hace para saber si el usuario es administrador o no
                      // dependiendo el resultado en caso que sea administrador habran mas funciones
                      FutureBuilder(
                          future: getUsuario(), // llamar a todos los usuarios
                          builder: (context,
                              AsyncSnapshot<List<UsuariosModel>> usuarioRol) {
                            // mientras carga la información
                            if (usuarioRol.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return SizedBox(
                              height: 1340,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Cards(),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future:
                                            getReservas(), // llama todas las reservas
                                        builder: (context,
                                            AsyncSnapshot<List<ReservaModel>>
                                                reserva) {
                                          // Mientras carga la información
                                          if (reserva.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          // Reservas pendientes Usuario
                                          return ReservaPendienteU(
                                            reservas: reserva.data!,
                                            themeManager: themeManager,
                                          );
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Reservas activas Usuario
                                    ReservaActivaU(
                                      themeManager: themeManager,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    // Reservas canceladas Usuario
                                    const ReservaCanceladaU(),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future:
                                            getReservas(), // llama todas las reservas
                                        builder: (context,
                                            AsyncSnapshot<List<ReservaModel>>
                                                reserva) {
                                          // Mientras carga la información
                                          if (reserva.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }

                                          // Reservas finalizadas Usuario
                                          return ReservaFinalizadaU(
                                            reservas: reserva.data!,
                                          );
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Pagos Usuario
                                    const Pagos(),
                                    const SizedBox(height: defaultPadding),
                                    // Devoluciones Usuario
                                    const Devoluciones(),
                                    const SizedBox(height: defaultPadding),
                                    // Multas Usuario
                                    const Multas(),
                                    const SizedBox(height: defaultPadding),
                                    const Divider(
                                      height: 1,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    // Panel Anfitrión
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Panel Anfitrión",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    // Sitios del anfitrión
                                    MisSitios(
                                      themeManager: themeManager,
                                    ),
                                    const SizedBox(height: defaultPadding),
                                    // Pagos al anfitrión
                                    const PagosAnf(),
                                    const SizedBox(height: defaultPadding),
                                    // reservas activas anfitrión
                                    const ReservaActivaA(),
                                    const SizedBox(height: defaultPadding),
                                    // reservas canceladas anfitrión
                                    const ReservaCanceladaA(),
                                    const SizedBox(height: defaultPadding),
                                    FutureBuilder(
                                        future:
                                            getReservas(), // llamar todas las reservas
                                        builder: (context,
                                            AsyncSnapshot<List<ReservaModel>>
                                                reserva) {
                                          // mientras carga la información
                                          if (reserva.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          // reservas finalizadas anfitrión
                                          return ReservaFinalizadaA(
                                            reservas: reserva.data!,
                                          );
                                        }),
                                    const SizedBox(height: defaultPadding),
                                    // Verificación administrador
                                    // Panel administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const Divider(
                                            height: 1,
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Panel Administrador",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium,
                                              ),
                                            ],
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // todos los sitios del aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          Sitios(
                                            themeManager: themeManager,
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // todos los pagos de las reservas
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const PagosTotal(),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // Todas las devoluciones
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          DevolucionesTotal(
                                            themeManager: themeManager,
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // pagos hechos a anfitriones
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          PagosTotalAnf(
                                            themeManager: themeManager,
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // Total de multas del aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const MultasTotal(),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // todos los usuarios del aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          ListaUsuario(
                                            themeManager: themeManager,
                                          ),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // reservas pendientes aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          FutureBuilder(
                                              future:
                                                  getReservas(), // lamar todas las reservas
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<ReservaModel>>
                                                      reserva) {
                                                // Mientras carga la información
                                                if (reserva.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                return ReservaPendienteT(
                                                  reservas: reserva.data!,
                                                  themeManager: themeManager,
                                                );
                                              }),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // reservas activas aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const ReservaActivaT(),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // reservas canceladas aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const ReservaCanceladaT(),
                                    // Verificación administrador
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          const SizedBox(
                                              height: defaultPadding),
                                    // Verificación administrador
                                    // reservas finalizadas aplicativo
                                    for (int index = 0;
                                        index < usuarioRol.data!.length;
                                        index++)
                                      if (FirebaseAuth
                                              .instance.currentUser!.email ==
                                          usuarioRol
                                              .data![index].correoElectronico)
                                        if (usuarioRol.data![index].rolAdmin !=
                                            false)
                                          FutureBuilder(
                                              future:
                                                  getReservas(), // llamar a todas las reservas
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          List<ReservaModel>>
                                                      reserva) {
                                                // mientras se carga la información
                                                if (reserva.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                return ReservaFinalizadaT(
                                                  reservas: reserva.data!,
                                                );
                                              }),
                                  ],
                                ),
                              ),
                            );
                          }),
                      // si el ancho de pantalla es movil aparecera los sitios visitados y favoritos al finalizar la pantalla
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            FutureBuilder(
                                future:
                                    getUsuario(), // llamar a todos los usuarios
                                builder: (context,
                                    AsyncSnapshot<List<UsuariosModel>>
                                        usuarios) {
                                  // mientras se carga la información
                                  if (usuarios.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  // Sitios Visitados
                                  return FutureBuilder(
                                      future: getSitioVisitado(),
                                      builder: (context,
                                          AsyncSnapshot<
                                                  List<SitioVisitadoModel>>
                                              sitioVisitados) {
                                        if (sitioVisitados.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return VisitadoDetails(
                                          themeManager: themeManager,
                                          listasitios: sitioVisitados.data!,
                                          listausuarios: usuarios.data!,
                                        );
                                      });
                                }),
                            const SizedBox(height: defaultPadding),
                            // Sitios favoritos
                            FavoritoDetails(
                              themeManager: themeManager,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Si el ancho de pantalla es diferente al de movil los sitios favoritos y visitados se colocaran en la parte derecha de la vista
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: getUsuario(), // llama a todos los usuarios
                            builder: (context,
                                AsyncSnapshot<List<UsuariosModel>> usuarios) {
                              // mientras se carga la información
                              if (usuarios.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return FutureBuilder(
                                  future:
                                      getSitioVisitado(), // llama a todos los sitios visitados
                                  builder: (context,
                                      AsyncSnapshot<List<SitioVisitadoModel>>
                                          sitioVisitados) {
                                    // Mientras se carga la información
                                    if (sitioVisitados.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    //Sitios Visitados
                                    return VisitadoDetails(
                                      themeManager: themeManager,
                                      listasitios: sitioVisitados.data!,
                                      listausuarios: usuarios.data!,
                                    );
                                  });
                            }),
                        const SizedBox(height: defaultPadding),
                        // Sitios Favoritos
                        FavoritoDetails(
                          themeManager: themeManager,
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
